$(document).ready(function () {
    $("div.trigger").click(function () {
      $("div.welcome").addClass("show");
      $("div.welcome").click(function () {
        $(this).removeClass("show");
      });
    });
  });
  