(ns rad.gr
  "This is currently doomed, as gnuradio uses Python 2.7,
  and libpython-clj requires Python 3.6 or later."
  (:require [libpython-clj.require :refer [require-python]]
            [libpython-clj.python :as py :refer [py. py.. py.-]]))

(require-python '[gnuradio :as gr])

