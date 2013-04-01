define(['zest', 'amdquery!bean', 'css!./button-blueios'], function($z, $) {
  return {
    render: function(o) {
      return '<button class="' + $z.esc(o.mode, 'attr') + '">' + o.text + '</button>';
    },
    pipe: true,
    attach: function(el, o) {
      if (o.click)
        $(el).click(o.click);
      return {
        dispose: function() {
          $(el).off('click');
        }
      };
    }
  };
});