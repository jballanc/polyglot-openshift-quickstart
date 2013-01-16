(ns immutant.init
  (:require immutant.web)
  (:use [ring.util.response :only [redirect]]))

(defn handler [request]
  (redirect "index.html"))

(immutant.web/wrap-resource handler "public")
