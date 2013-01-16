(ns immutant.init
  (:require immutant.web)
  (:use [ring.util.response :only [redirect]]))

(defn handler [request]
  (redirect  (str  (:context request "/index.html"))))

(immutant.web/start (immutant.web/wrap-resource handler "public"))
