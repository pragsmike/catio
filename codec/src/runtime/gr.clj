(ns runtime.gr
  "This might work, if gnuradio support Python >= 3.6,
  as libpython-clj requires Python 3.6 or later."
  (:require [libpython-clj.require :refer [require-python]]
            [libpython-clj.python :as py :refer [py. py.. py.-]]))

(require-python '[gnuradio :as gr])

