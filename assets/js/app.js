// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"
import Alpine from "alpinejs"
import Chart from "chart.js/auto";

let hooks = {};

hooks.optionTextInput = {
  mounted(){

    this.handleEvent("clear-input", () => {
      this.el.value = ""
    })
  }
}

hooks.voteChart = {
  mounted() {

    var voteCtx = document.getElementById("voteChart").getContext("2d");
    var voteChart = new Chart(voteCtx, {
      type: 'bar',
    data: {
        labels: [],
        datasets: [{
            label: '# of Votes',
            data: [],
            borderWidth: 1,
            backgroundColor: [
              'rgba(255, 99, 132, 0.2)',
              'rgba(54, 162, 235, 0.2)',
              'rgba(255, 206, 86, 0.2)',
              'rgba(75, 192, 192, 0.2)',
              'rgba(153, 102, 255, 0.2)',
              'rgba(255, 159, 64, 0.2)'
          ],
          borderColor: [
              'rgba(255, 99, 132, 1)',
              'rgba(54, 162, 235, 1)',
              'rgba(255, 206, 86, 1)',
              'rgba(75, 192, 192, 1)',
              'rgba(153, 102, 255, 1)',
              'rgba(255, 159, 64, 1)'
          ],
        }]
    },
    options: {
        plugins: {
            title: {
                display: true,
                text: 'Title'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                  stepSize: 1
              }
            }
        }
    }
    });


    this.handleEvent("chart-data", (data) => {
      const labels = Object.keys(data.data)
      const votes = Object.values(data.data)
      
      voteChart.data.datasets[0].data = votes;
      voteChart.data.labels = labels;
      voteChart.options.plugins.title.text = data.label
      voteChart.update();

    });

  },
};




let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
    params: {_csrf_token: csrfToken},
    dom: {
        onBeforeElUpdated(from, to) {
          if (from.__x) { Alpine.clone(from.__x, to) }
        }
      },
    hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

