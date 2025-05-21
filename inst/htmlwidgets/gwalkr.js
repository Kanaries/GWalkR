HTMLWidgets.widget({

  name: 'gwalkr',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        const store = GWalkRApp(x, el.id);

        if (store && typeof window !== 'undefined') {
          window.gwalkrStores = window.gwalkrStores || {};
          window.gwalkrStores[el.id] = store;
        }

      },

        resize: function(width, height) {

          // TODO: code to re-render the widget with a new size

        }

      };
    }
  });

if (typeof window !== 'undefined' && HTMLWidgets.shinyMode) {
  Shiny.addCustomMessageHandler('gwalkr_get_visconfig', function(message) {
    const id = message.id;
    const config = window.exportGWalkRConfig ? window.exportGWalkRConfig(id) : null;
    Shiny.setInputValue(id + '_visConfig', config, {priority: 'event'});
  });
}
