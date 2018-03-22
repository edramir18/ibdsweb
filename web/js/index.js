const categorias = []
const canales = []
const host = '172.30.0.250:8080'
const baseUrl = `http://${host}/ords/ibds/`

let currentCharts = []

function fecthJSON (url) {
  return fetch(url).then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok.')
    }
    return response.json()
  })
}

document.addEventListener('DOMContentLoaded', () => {  
  const day = moment().day()
  const buttons = document.querySelectorAll('.toolbar>button')  
  buttons.forEach((b, i) => {
    const today = moment()
    if (i <= day) {
      today.add(i - day, 'days')
    } else {
      today.subtract(7 - (i - day), 'days')
    }
    b.dataset.fecha = today.format('YYYYMMDD')
    b.textContent = today.format('ddd DD')
    b.addEventListener('click', generateCharts)
  })

  fecthJSON(`${baseUrl}/categoria/`).then(json => {    
    json['items'].forEach(j => categorias.push(j))
  })
  fecthJSON(`${baseUrl}/canal/`).then(json => {    
    json['items'].forEach(j => canales.push(j))
    const target = document.querySelector('.charts')
    const template = document.querySelector('#chart')
    if (!target || !template) throw new Error('No available element to process.')
    canales.forEach(c => {      
      const node = template.content.cloneNode(true)
      node.querySelector('h3').textContent = c.nombre      
      node.querySelector('canvas').setAttribute('id', c.nombre)      
      target.appendChild(node)      
    })
  })
})

function generateCharts(e) {  
  while(currentCharts.length > 0) {
    currentCharts.pop().destroy()
  }

  const fecha = e.target.dataset.fecha
  canales.forEach(c => {
    const canal = c    
    fecthJSON(`${baseUrl}/logs/${canal.id}/${fecha}`).then(json => {
      createGraph(canal.nombre, json)
    })    
  })
}

function createGraph(target, json) {
  const labels = '0'.repeat(24).split('').map((v, i) => i)
  const config = createConfigGraph(labels, 'Hora', 'Usuarios')
  const data = {}
  categorias.forEach(c => { data[c.nombre] = { values: [], sign: c.orden < 0 ? -1 : 1} })  
  for (let hour = 0; hour < 24; hour++) {
    Object.values(data).forEach(d => d.values.push(0))
    if(!json.logs[hour]['CATEGORIAS']) continue
    json.logs[hour]['CATEGORIAS'].forEach(c => {
      if(c) {
        data[c.NOMBRE].values[hour] = data[c.NOMBRE].sign * c.TOTAL
      }
    })      
  }    
  config.data.datasets.forEach((dataset) => {
    dataset.data = data[dataset.label].values
  })
  const ctx = document.getElementById(target).getContext('2d')
  currentCharts.push(new Chart(ctx, config))
}

function createConfigGraph (labels, xLabel, yLabel) { 
  const categoriaSets = categorias.map( c => {
    return createDataSet(c.nombre, `${c.color}, 0.7`, c.fill)
  })  
  const dataConfig = {
    labels: labels,
    datasets: categoriaSets
  }
  const optionsConfig = {
    tooltips: {
      mode: 'index',
      intersect: false
    },
    scales: {
      xAxes: [{
        scaleLabel: {
          display: true,
          labelString: xLabel
        }
      }],
      yAxes: [{
        stacked: true,
        scaleLabel: {
          display: true,
          labelString: yLabel
        }
      }]
    }
  }
  const config = {
    type: 'line',
    data: dataConfig,
    options: optionsConfig
  }
  return config
  function createDataSet (name, color, fillMode) {
    return {
      label: name,
      data: [],
      borderColor: `rgba(${color})`,
      backgroundColor: `rgba(${color})`,
      pointRadius: 1,
      pointHoverRadius: 10,
      fill: fillMode
    }
  }
}
