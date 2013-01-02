{
 :root (str (System/getenv "OPENSHIFT_REPO_DIR") "/your-clojure-app")
 :context-path "/"
 :swank-port 24005
 :nrepl-port 27888

 ;; :lein-profiles [:prod :foo]
}
