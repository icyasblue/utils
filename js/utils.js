var Utils = {
  format : function (str, args) {
    var base = '';
    var open = 0;
    var key = '';
    for (var i = 0; i < str.length; i ++) {
      switch (str[i]) {
        case '{':
          if(open)
            base += '{';
          else
            open = 1;
          break;
        case '}':
          if (open) {
            if (!key) {
              if (str[i+1] == '}')
                base += '}';
              else
                open = 0;
            } else {
              if (!args[key]) {
                throw('Missing key ' + key + ' in the arguments');
              }
              base += args[key];
              key = '';
              open = 0;
            }
          } else {
            throw('more } than {!');
          }
          break;
        default:
          if (open)
            key += str[i];
          else
            base += str[i];
      }
    }
    return base;
  },

  merge: function(dest, obj, override = 1) {
    for (var key in Object.keys(obj)) {
      if (!override && dest.hasOwnProperty(key))
        continue;
      dest[key] = obj[key];
    }
  }
};

module.exports = Utils;