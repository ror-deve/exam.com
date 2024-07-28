function paperPieChart(id, labels, data){
  var ctx = document.getElementById(id);
  var data = {
    labels: labels,
    datasets: [{ data: data, 
      backgroundColor: dynamicColors, 
      hoverBackgroundColor: dynamicHovers
    }],
  };
  var myPieChart = new Chart(ctx, {
      type: 'pie',
      data: data
  });
}

function barChart(id, labels, data , data2){
  var ctx = document.getElementById(id);
  var data = {
    labels: labels,
    datasets: [{ data: data, 
      label: "Correct questions",
      backgroundColor: dynamicColors, 
      hoverBackgroundColor: dynamicHovers
    },
    { data: data2, 
      label: "No. of questions",
      backgroundColor: "rgba(220,220,220,2)", 
      hoverBackgroundColor: "rgba(220,220,220,0.5)"
    }
  ],
  };
  var barChart = new Chart(ctx, {
      type: 'bar',
      data: data,
    options: {
            scales: {
                yAxes: [{
                  scaleLabel: {
                          display: true,
                          labelString: 'No. of Ques'
                        },
                    ticks: {
                        beginAtZero:true
                    }
                }],
                xAxes: [{
                  stacked: true,
                  scaleLabel: {
                    display: true,
                    labelString: 'Topics'
                  }
                }]
            }
        }
  });
}


function barChartPaper(id,labels, data, data2,label1,label2){
  var ctx = document.getElementById(id);
  var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: label1,
        data: data,
        backgroundColor: dynamicColors[18],
        borderColor: dynamicBorders[18],
        hoverBackgroundColor: dynamicHovers[18],
        borderWidth: 1
    },{
        label: label2,
        data: data2,
      backgroundColor: dynamicColors[20],
      borderColor: dynamicBorders[20],
      hoverBackgroundColor: dynamicHovers[20],
        borderWidth: 1
      }]
    },
    options: {
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero:true
          }
        }]
      }
    }
  });
}

function polarChart(id, data, labels){
  var ctx = document.getElementById(id);
  var data = {
      datasets: [{data: data, backgroundColor: dynamicColors, borderColor: dynamicBorders}],
      labels: labels
  };
  
var myPolarChart = new Chart(ctx, { data: data, type: 'polarArea'});
}

