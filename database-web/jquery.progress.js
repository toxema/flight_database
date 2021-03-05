/* jQuery Progress Bar Plugin - v1.0.0
 * Copyright (c) 2015 Zeyu Feng; Licensed MIT
 * https://github.com/clarkfbar/jquery.progress
 * */

$.fn.extend({
  Progress: function (options) {
    var settings = {
      width: 100, // ?????
      height: 20, // ?????
      percent: 0, // ????
      backgroundColor: '#555', // ???????
      barColor: '#37c871', // ?????
      fontColor: '#fff', // ???????
      radius: 2, // ????
      fontSize: 12, // ????
      increaseTime: 1000.00 / 60.00, // ???????????, ??????(?????????)????animate?true??????
      increaseSpeed: 1, // ?????????????animate?true??????
      animate: false // ??????????????????true
    };
    $.extend(settings, options);

    var $svg = $(this), $background, $bar, $g, $text, timeout;

    function progressPercent(p) {
      if (!$.isNumeric(p) || p < 0) {
        return 0;
      } else if (p > 100) {
        return 100;
      } else {
        return p;
      }
    }

    // ??????
    var Animate = {
      getWidth: function () {
        // ??????????????percent
        return settings.width * settings.percent / 100.00;
      },
      getPercent: function (currentWidth) {
        // ?????????????percent
        return parseInt((100 * currentWidth / settings.width).toFixed(2));
      },
      animateWidth: function (currentWidth, targetWidth) {
        // ????
        timeout = setTimeout(function () {
          if (currentWidth > targetWidth) {
            if (currentWidth - settings.increaseSpeed <= targetWidth) {
              currentWidth = targetWidth;
            } else {
              currentWidth = currentWidth - settings.increaseSpeed;
            }
          } else if (currentWidth < targetWidth) {
            if (currentWidth + settings.increaseSpeed >= targetWidth) {
              currentWidth = targetWidth;
            } else {
              currentWidth = currentWidth + settings.increaseSpeed;
            }
          }

          $bar.attr("width", currentWidth);
          $text.empty().append(Animate.getPercent(currentWidth) + "%");

          if (currentWidth != targetWidth) {
            Animate.animateWidth(currentWidth, targetWidth);
          }
        }, settings.increaseTime);
      }
    }

    function svg(tag) {
      return document.createElementNS("http://www.w3.org/2000/svg", tag);
    }

    // ?????
    !!function () {
      settings.percent = progressPercent(settings.percent);

      $svg.attr({ 'width': settings.width, 'height': settings.height });

      $background = $(svg("rect")).appendTo($svg)
        .attr({ x: 0, rx: settings.radius, width: settings.width, height: settings.height, fill: settings.backgroundColor });

      $bar = $(svg("rect")).appendTo($svg)
        .attr({ x: 0, rx: settings.radius, height: settings.height, fill: settings.barColor });

      $g = $(svg("g")).appendTo($svg)
        .attr({ "fill": "#fff", "text-anchor": "start", "font-family": "DejaVu Sans,Verdana,Geneva,sans-serif", "font-size": settings.fontSize });

      $text = $(svg("text")).appendTo($g)
        .attr({ "x": 10, "y": settings.height / 2.0 + settings.fontSize / 3.0, fill: settings.fontColor });

      draw();
    }();

    // ?????
    function draw() {
      var targetWidth = Animate.getWidth();

      // ????????
      if (settings.animate) {
        if (timeout) {
          clearTimeout(timeout);
        }
        var currentWidth = parseFloat($bar.attr("width"));
        if (!currentWidth) currentWidth = 0;

        Animate.animateWidth(currentWidth, targetWidth);
      } else {
        $bar.attr("width", targetWidth);
        $text.empty().append(settings.percent + "%");
      }
    }

    this.percent = function (p) {
      if (p) {
        p = progressPercent(p);

        settings.percent = p;
        draw();
      }
      return settings.percent;
    }

    this.color = function (pp) {

      settings.barColor = pp;
      draw();

      return settings.barColor;
    }
    return this;
  }
});