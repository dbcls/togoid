require.context('../images', true, /\.(png|jpg|jpeg|svg)$/);

import 'stylesheets/application';

import 'bootstrap/dist/js/bootstrap';

import Routes from '../javascripts/js-routes.js.erb';
window.Routes = Routes;
