var plauscherlLocation = window.plauscherlLocation;
var mapLocation = new google.maps.LatLng(plauscherlLocation.lat, plauscherlLocation.lng);
(function initialize() {
	var mapOptions = {
		center: mapLocation,
		zoom: 18,
		scrollwheel: false,
		draggable: false,
		zoomable: false,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};
	var map = new google.maps.Map(document.getElementById("map-canvas"),
		mapOptions);

	var mql1 = window.matchMedia('(min-width: 40em');
	mql1.addListener(function(m) {
		if(m.matches) {
			map.panBy(200,0);
			map.setCenter(mapLocation);
		}
	});

	var mql2 = window.matchMedia('(min-width: 60em');
	mql2.addListener(function(m) {
		if(m.matches) {
			map.panBy(200,0);
			map.setCenter(mapLocation);
		}
	});

	var mql3 = window.matchMedia('(max-width: 40em');
	mql3.addListener(function(m) {
		if(m.matches) {
			map.panBy(0,0);
			map.setCenter(mapLocation);
		}
	});

	if(window.innerWidth >= 40*16) {
		map.panBy(200,0);
	}

	var marker = new google.maps.Marker({
		position: mapLocation,
		title: plauscherlLocation.name
	});

	marker.setMap(map);
})();
