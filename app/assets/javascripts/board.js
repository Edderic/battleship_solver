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

$(document).on('click', 'td[data-row]', function() {
  var oldStatus = $(this).data('status');
  var newStatusObj = StatusHandler(oldStatus).next();
  // $(this).data('status', newStatusObj.status())
  $(this).attr('data-status', newStatusObj.status())
  var statuses = $('td[data-row]').map(function() {
    return $(this).attr('data-status')
  })
  console.log(statuses)

  $.post("/rerender_table", {"statuses[]": $.makeArray(statuses)}, function(responseData) {
    $('table').html(responseData)
  }, 'html')
  //
  // Need to get all the sunken points, hit points, missed points, available ships
  // Send that over to the root endpoint
})
