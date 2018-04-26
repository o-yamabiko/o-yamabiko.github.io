function showtext() {
  // Get the checkbox
  var checkBox = document.getElementById("hyoji");
  // Get the output text
  var bun = document.getElementById("bun");
  var view = document.getElementById("view");
  var logo = document.getElementById("logo");

  // If the checkbox is checked, display the output text
  if (checkBox.checked == true){
    bun.style.display = "block";
    view.style.display = "inline";
    logo.style.display = "none";
  } else {
    bun.style.display = "none";
    view.style.display = "none";
    logo.style.display = "block";
  }
};

