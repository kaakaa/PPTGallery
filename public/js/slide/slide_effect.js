var EFFECT = {
  FADE: 0,
  SLIDE: 1,
  UPDOWN: 2,
};
var nowEffect = EFFECT.FADE;

function getEffectMenu() {
  var tags = "";
  for(param in EFFECT){
    var className = "effect-menu-" + EFFECT[param];
    tags += "<p><a id='" + className + "' href='javascript:void(0);'>" + param + "</a></p>";
  }
  return tags;
}

$(document).on('click', "a[id^='effect-menu-']", function(){
  nowEffect = Number($(this).attr("id").slice(-1));
});

function getEffectSetting(func) {
  return {
    duration: 750,
    queue: false,
    complete: func
  };
}

function getSlideEffect(pattern, direction) {
  switch(pattern) {
  case EFFECT.UPDOWN:
    return function(now, next){
          var imgHeight = now.height();

          var pre = function(){
            next.toggle();
            next.css("opacity", "0.1");
            if(direction == 'prev'){
              next.css("margin-top", -1 * imgHeight);
            } 
          };

          var sliding = function(){
            var afterFunction = function(){ $(this).css("margin-top", 0); };
            if(direction == 'prev'){
              now.animate(
                { opacity: "toggle" },
                getEffectSetting(afterFunction)
              );
              next.animate(
                { marginTop: 0, opacity: 1 },
                getEffectSetting(afterFunction)
              );
            } else {
              now.animate(
                { marginTop: -1 * imgHeight, opacity: "toggle" },
                getEffectSetting(afterFunction)
              ); 
              next.animate(
                { marginTop: 0, opacity: 1 },
                getEffectSetting(afterFunction)
              ); 
            }
          };

          pre();
          sliding();
        };
  case EFFECT.SLIDE:
    return function(now, next){
          var movement = $(window).width();
          if(direction == "next"){
            movement *= -1;
          }

          var pre = function(){
            next.css('opacity',0);
            next.toggle();
            if(movement < 0){
              var pad = ($(window).width() - now.width()) / 2;
              next.css("margin-left", pad + now.width());
            } else {
              var nextWidth = next.width();
              var pad = ($(window).width() - nextWidth) / 2;
              now.css("margin-left", pad);
              next.css("margin-left", -1 * (nextWidth + pad));
            }
          }

          var sliding = function() {
            var nowWidth = now.width();
            var pad = ($(window).width() - nowWidth) / 2;
            var afterFunctionZero = function(){ $(this).css("margin-left", 0) };
            var afterFunctionPad = function(){ $(this).css("margin-left", pad) };

            if(movement < 0){
              now.animate(
                { marginLeft: movement, opacity: "toggle" },
                getEffectSetting(afterFunctionZero)
              );
              next.animate(
                { marginLeft: -1 * (nowWidth + movement + pad), opacity: "1.0" },
                getEffectSetting(afterFunctionPad)
              );
            } else {
              now.animate(
                { marginLeft: nowWidth + pad + pad, opacity: "toggle" },
                getEffectSetting(afterFunctionZero)
              );
              next.animate(
                { marginLeft: pad, opacity: "1.0" },
                getEffectSetting(afterFunctionPad)
              );
            }
          }

          pre();
          sliding();
        };
  case EFFECT.FADE:
  default:
    return function(now, next){
        now.fadeOut("fast", function(){
          next.fadeIn("fast");
        });
    };
  }
}


function pre(movement, now, next){
}

