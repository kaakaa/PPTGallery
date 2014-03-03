var wrapper = $("div#wrapper");
var resize = function(page) {
  var scale = Math.min($(window).width() / page.width(), $(window).height() / page.height());
  page.width(page.width() * scale);
  var pad = ($(window).width() - page.width()) / 2;
  console.log(pad);
  page.css("margin-left", pad);
};
function setPageNumber(current) {
  var allNumber = wrapper.find("img").size();
  $("#pageNumber").text((current + 1) + '/' + allNumber);
};
$(document).ready( function() {
  setPageNumber(0);
  resize(wrapper.find("img:visible"));
  spotOneInAllSlide(0);
});
function spotOneInAllSlide(current) {
  slides = $('#allslide .one-of-all-slide');
  $.each(slides, function(i,val) {
    if(i == current){
      $(val).find('input').addClass('selected-slide');
    } else {
      $(val).find('input').removeClass('selected-slide');
    }
  });
};
function toggleAllSlide() {
  $('div#allslide').fadeToggle();
};
function selectPage(index){
  goPage(index);
  toggleAllSlide();
};
function go(page, direction) {
  var now = wrapper.find("img:visible");
  var sliding = getSlideEffect(nowEffect, direction);
  if($('div#wrapper img').index(page) != $('div#wrapper img').index(now)) {
    sliding(now, page);
    setPageNumber($('div#wrapper img').index(page));
    console.log(page.css('margin-left'));
  }
};
$("input:button.prev").click(function() {
  var prev = wrapper.find("img:visible").prev();
  if(prev.length != 0){
    go(prev, "prev");
  }
});
$("input:button.next").click(function() {
  var next = wrapper.find("img:visible").next();
  if(next.length != 0){
    go(next, "next");
  }
});
$("input.next,input.prev").hover( function() {
  $(this).css('width', $(window).width() / 5);
  $(this).css('height', $(window).height());
  $(this).css('opacity', '1');
}, function(){
  $(this).css('opacity', '0');
});
function goFirst(){
  var first = wrapper.find('img:first');
  go(first, "prev");
}
function goPrev(){
  var prev = wrapper.find('img:visible').prev();
  if(prev.length != 0) {
    go(prev, "prev");
  }
}
function goNext(){
  var next = wrapper.find('img:visible').next();
  if(next.length != 0) {
    go(next, "next");
  }
}
function goLast(){
  var last = wrapper.find('img:last');
  go(last, "next");
}
function goPage(index){
  var page = wrapper.find('img:eq(' + index + ')');
  go(page, "none");
}
$('#toggle_controller').click(function(){
  var ctr_position = ($('#controller').position().top / $(window).height()) * 100;
  if(~~ctr_position == 95){
    $('#controller').animate({'top': '100%'});
    $('#toggle_controller').animate({'top': '95%'});
  }
  if(~~ctr_position == 100){
    $('#controller').animate({'top': '95%'});
    $('#toggle_controller').animate({'top': '90%'});
  }
});
$("#settings").children("button.settings-button").click(function() {
  console.log("setting button push");
  tags = getEffectMenu();
  console.log(tags);
  $("#settings").append(tags);
});

