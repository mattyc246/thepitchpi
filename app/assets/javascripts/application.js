// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .



// USER LOCATION AND DISTANCE------------USER LOCATION AND DISTANCE--------------USER LOCATION AND DISTANCE----------------

// detect it is mobile
// if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {




$(document).ready(function(){


				setInterval(function(){

				navigator.geolocation.getCurrentPosition(function(location){
				 var lng = location.coords.longitude;
				 var lat = location.coords.latitude;
				 var acc = location.coords.accuracy;


					$.ajax({

						url: '/locks/distance_check',
						method: 'GET',
						dataType: 'JSON',
						data: {current_lng: lng ,  current_lat: lat,  current_acc: acc},
						success: function(data){
							console.log(data);
							$(".distance").html(data.distance)
							$(".db_status").html(String(data.status_db))
							$(".acc").html(data.acc)
							$(".in_range").html(data.in_range)
							// if (status == "Unlocked"){
							// 	$('#testing-here').removeClass('bg-success');
							// 	$('#testing-here').addClass('bg-danger');
							// } else if (status == "Locked"){
							// 	$('#testing-here').removeClass('bg-danger');
							// 	$('#testing-here').addClass('bg-success');
							// }
						}
					})})}, 5000);

			})

// }



// NOT USED---------------NOT USED---------------NOT USED---------------NOT USED---------------
// when positon change
// id = navigator.geolocation.watchPosition(success[, error[, options]])
