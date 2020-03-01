(defproject strung "0.1.0-SNAPSHOT"
  :description "String diagram UI components"
  :dependencies [
                 [org.clojure/clojure       "1.10.1"]
                 [org.clojure/clojurescript "1.10.597"]
                 [reagent                   "0.9.1"]
                 [re-frame                  "RELEASE"]
                 [strowger                  "0.1.4"]
                 [org.clojure/core.async  	"0.4.474"]
                 [cljsjs/pako "0.2.7-0"]]

  :profiles {:dev {:dependencies
                   [[com.bhauman/figwheel-main "0.1.9"]
                    [com.bhauman/rebel-readline-cljs "0.1.4"]]}}

  :source-paths ["src/cljs" "src/cljc" "test/cljc" "test/cljs"]
  :resource-paths ["resources" "target"]

  :clean-targets ^{:protect false} ["target/public"]

  :aliases {"fig" ["trampoline" "run" "-m" "figwheel.main"]
            "fig:build" ["trampoline" "run" "-m" "figwheel.main" "-b" "dev" "-r"]})
