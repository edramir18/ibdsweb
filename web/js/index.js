const categorias = []
const host = '172.30.0.250:8080'
const baseUrl = `http://${host}/ords/ibds/`

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
})

function generateCharts(e) {
  const fecha = e.target.dataset.fecha
  fecthJSON(`${baseUrl}/logs/${fecha}`).then(json => {
    console.log(json)
  })
}