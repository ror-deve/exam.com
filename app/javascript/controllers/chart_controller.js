import ApexCharts from "../apexchart";
import * as echarts from '../echarts';


window.echarts = echarts;

const ChartController = () => {
  $(document).ready(function() {
    var subjectsData = JSON.parse(document.getElementById('subjectChart').dataset.subjects);
    console.log(subjectsData)
    echarts.init(document.querySelector("#subjectChart")).setOption({
      tooltip: {
        trigger: 'item'
      },
      legend: {
        top: '5%',
        left: 'center'
      },
      series: [{
        name: 'Topics',
        type: 'pie',
        radius: ['40%', '70%'],
        avoidLabelOverlap: false,
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: '18',
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: subjectsData
      }]
    });
  });

  document.addEventListener('DOMContentLoaded', function() {
    const examsChart = document.getElementById('examsChart');
    if (examsChart) {
      const examsData = JSON.parse(examsChart.getAttribute('data-subjects'));
      
      echarts.init(examsChart).setOption({
        tooltip: {
          trigger: 'item'
        },
        legend: {
          top: '5%',
          left: 'center'
        },
        series: [{
          name: 'Papers',
          type: 'pie',
          radius: ['40%', '70%'],
          avoidLabelOverlap: false,
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: '18',
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: examsData
        }]
      });
    }
  });
}

export { ChartController };
