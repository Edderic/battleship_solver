Untried = function Untried() {
  this.next = function next() {
    return new Missed();
  }

  this.status = function status() {
    return 'untried'
  }
}

Missed = function Missed() {
  this.next = function next() {
    return new Hit();
  }

  this.status = function status() {
    return 'missed'
  }
}

Hit = function Hit() {
  this.next = function next() {
    return new Sunk();
  }

  this.status = function status() {
    return 'hit'
  }
}

Sunk = function Sunk() {
  this.next = function next() {
    return new Untried();
  }

  this.status = function status() {
    return 'sunk'
  }
}

String.prototype.upcase = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}

StatusHandler = function StatusHandler(status) {
  return new window[status.upcase()]()
}

function rerenderBody() {
  var statuses = $('td[data-row]').map(function() {
    return $(this).data('status')
  })

  var ship_ids = $.makeArray($('#ships input[type=checkbox]').map(function() { return $(this).data('id'); }))
  var ship_values = $.makeArray($('#ships input[type=checkbox]').map(function() { return this.checked; }))
  var ship_length = $.makeArray($('#ships input[type=checkbox]').map(function() { return $(this).data('length'); }))

  var ships = []

  for(var i = 0; i < ship_ids.length; i++) {
    var ships_obj = {};
    ships_obj['ship_id'] = ship_ids[i];
    ships_obj['ship_value'] = ship_values[i];
    ships_obj['ship_length'] = ship_length[i];
    ships.push(JSON.stringify(ships_obj));
  }

  $.post("/rerender_table", {"statuses[]": $.makeArray(statuses), "ships[]": ships}, function(responseData) {
    $('body').html(responseData)
  }, 'html')
}

$(document).on('click', 'td[data-row]', function() {
  var oldStatus = $(this).data('status');
  var newStatusObj = StatusHandler(oldStatus).next();
  $(this).data('status', newStatusObj.status())

  rerenderBody();
})

$(document).on('click', 'ul#ships input[type="checkbox"]', function() {
  rerenderBody();
})


