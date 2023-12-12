"use strict";
import { MAVAITRO, menu, menuShow, highLightMenu } from "./menu.js";
import { toExcel, toPDF, getFetch } from "./helper.js";

async function nguyenLieu() {
  try {
    let data = await getFetch("../ajax/baoCao.php", {
      action: "nguyenLieu",
    });
    return data;
  } catch (error) {
    return null;
  }
}
async function thanhPham() {
  let data = await getFetch("../ajax/baoCao.php", {
    action: "thanhPham",
  });
  return data;
}
let uniqueSP;
let dsUniqueSP;
let dsNhap;
let data;
let colors = [
  "rgb(255, 99, 132)", // Đỏ
  "rgb(54, 162, 235)", // Xanh dương
  "rgb(255, 206, 86)", // Vàng
  "rgb(75, 192, 192)", // Xanh lá
  "rgb(153, 102, 255)", // Tím
  "rgb(255, 159, 64)", // Cam
  "rgb(53, 102, 235)", // Xanh lam
  "rgb(255, 99, 132)", // Hồng
  "rgb(54, 162, 235)", // Xanh dương nhạt
  "rgb(75, 192, 192)", // Xanh lá nhạt
];
let myPieChart = false;
let myLineChart = false;
let myPieChart2 = false;
let mybarChart = false;
function render() {
  let html = `${menu()}`;
  let container = document.querySelector(".container");
  container.insertAdjacentHTML("afterbegin", html);
  menuShow();
  highLightMenu();
}
function content() {
  const pieChart = document.querySelector(".pieChart").getContext("2d");
  myPieChart = pieChartVisual(pieChart);
  const pieChart2 = document.querySelector(".pieChart2").getContext("2d");
  myPieChart2 = pieChartNhapXuatVisual(pieChart2);
  const barChart = document.querySelector(".barChart").getContext("2d");
  mybarChart = barChartVisual(barChart);
  const lineChart = document.querySelector(".lineChart").getContext("2d");
  myLineChart = lineChartVisual(lineChart);
}

function barChartVisual(ctx) {
  let top10 = dsUniqueSP.slice(0, 10);
  const data = {
    labels: top10.map((d) => d.TenSanPham),
    datasets: [
      {
        data: top10.map((d) => d.SoLuongTon),
        backgroundColor: colors,
        hoverOffset: 4,
      },
    ],
  };

  const config = {
    type: "bar",
    data: data,
    options: {
      maintainAspectRatio: true,
      plugins: {
        legend: {
          display: false,
          position: "left",
        },
        title: {
          display: true,
          text: "Top 10 sản phẩm có số lượng tồn lớn nhất (KG)",
        },
      },
    },
  };
  if (mybarChart) {
    mybarChart.destroy();
  }
  const myChart = new Chart(ctx, config);

  return myChart;
}
function pieChartVisual(ctx) {
  const data = {
    labels: dsUniqueSP.map((d) => d.TenSanPham),
    datasets: [
      {
        data: dsUniqueSP.map((d) => d.SoLuongTon), // Dữ liệu biểu thị cho mỗi phần của pie chart
        backgroundColor: colors,
        hoverOffset: 4, // Khoảng cách khi hover chuột lên phần tử của biểu đồ
      },
    ],
  };

  const config = {
    type: "pie",
    data: data,
    options: {
      responsive: true,
      maintainAspectRatio: false,

      plugins: {
        legend: {
          display: true,
          position: "top",
        },
        title: {
          display: true,
          text: "Danh sách sản phẩm trong kho",
        },
      },
    },
  };
  if (myPieChart) {
    myPieChart.destroy();
  }
  const myChart = new Chart(ctx, config);
  return myChart;
}
function pieChartNhapXuatVisual(ctx) {
  let SoLuongChoNhap = dsUniqueSP.reduce((acc, d) => acc + d.SoLuongChoNhap, 0);
  let SoLuongChoXuat = dsUniqueSP.reduce((acc, d) => acc + d.SoLuongChoXuat, 0);
  console.log(SoLuongChoNhap, SoLuongChoXuat);
  const data = {
    labels: ["Số lường chờ xuất", "Số lượng chờ nhập"],
    datasets: [
      {
        data: [SoLuongChoXuat, SoLuongChoNhap], // Dữ liệu biểu thị cho mỗi phần của pie chart
        backgroundColor: colors,
        hoverOffset: 4, // Khoảng cách khi hover chuột lên phần tử của biểu đồ
      },
    ],
  };

  const config = {
    type: "pie",
    data: data,
    options: {
      responsive: true,
      maintainAspectRatio: false,

      plugins: {
        legend: {
          display: true,
          position: "top",
        },
        title: {
          display: true,
          text: "Nguyên liệu chờ nhập và xuất",
        },
      },
    },
  };
  if (myPieChart2) {
    myPieChart2.destroy();
  }
  const myChart = new Chart(ctx, config);

  return myChart;
}

function lineChartVisual(ctx) {
  const data = {
    labels: dsNhap.map((d) => d.NgayNhap),
    datasets: [
      {
        data: dsNhap.map((d) => d.SoLuong),
        backgroundColor: colors,
        hoverOffset: 4,
        tension: 0.1,
        fill: false,
        borderWidth: 1,
      },
    ],
  };

  const config = {
    type: "line",
    data: data,
    options: {
      borderColor: "red",
      scales: {
        y: {
          beginAtZero: true,
        },
        y: {
          ticks: {
            // Include a dollar sign in the ticks
            callback: function (value, index, ticks) {
              return " " + value;
            },
          },
        },
      },
      maintainAspectRatio: true,
      responsive: true,
      plugins: {
        legend: {
          display: false,
          position: "top",
        },
        title: {
          display: true,
          text: "Số lượng nhập theo ngày",
        },
      },
    },
  };
  if (myLineChart) {
    myLineChart.destroy();
  }
  const myChart = new Chart(ctx, config);
  return myChart;
}

async function init(ma = 1) {
  data = ma === 1 ? await nguyenLieu() : await thanhPham();
  if (data) trichXuatData(data);
  content();
  const select = document.querySelector("select");
  select.addEventListener("change", (e) => {
    changeSelect();
  });
}

function trichXuatData(data) {
  uniqueSP = [...new Set(data.map((d) => d.TenSanPham))];
  dsUniqueSP = uniqueSP.map((uSP) => {
    let ds = data.filter((d) => d.TenSanPham === uSP);
    return {
      TenSanPham: uSP,
      SoLuongTon: ds[0].SoLuongTon,
      SoLuongChoXuat: ds[0].SoLuongChoXuat,
      SoLuongChoNhap: ds[0].SoLuongChoNhap,
    };
  });
  dsUniqueSP = dsUniqueSP.sort((a, b) => b.SoLuongTon - a.SoLuongTon);
  dsNhap = [...new Set(data.map((d) => d.NgayLap))];
  dsNhap = dsNhap.map((nn) => {
    let ds = data.filter((d) => d.NgayLap === nn);
    return {
      NgayNhap: nn,
      SoLuong: ds.reduce((acc, d) => acc + d.SoLuong, 0),
    };
  });
}
async function changeSelect() {
  const selectValue = document.querySelector("select").value;
  if (selectValue == 1) {
    await init(1);
  } else {
    await init(2);
  }
}
render();
await init(1);
