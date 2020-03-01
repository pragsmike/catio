(ns strung.hio
  "Utilities to work with homotopy.io URLs.
   Extract proof from a URL string."
  (:require [goog.crypt.base64 :as b64]
            [cljsjs.pako]
            [goog.crypt :as c]))

;; http://www.onicos.com/staff/iz/formats/gzip.html
;; https://unix.stackexchange.com/questions/22834/how-to-uncompress-zlib-data-in-unix
;; https://stackoverflow.com/questions/9050260/what-does-a-zlib-header-look-like
;; https://lambdaisland.com/blog/2017-06-12-clojure-gotchas-surrogate-pairs


(defn jstr->clj [json]
  (js->clj (.parse js/JSON json) :keywordize-keys true))

(defn decode [s] (b64/decodeStringToByteArray s nil))

(defn byte-seq->string [arr] (c/utf8ByteArrayToString (apply array arr)))

(def zlib-header [0x1f 0x8b 0x08 0x00 0x00 0x00 0x00 0x00 0x00 0x00])


(defn deflate [b] (.deflate js/pako
                    (clj->js (concat zlib-header b zlib-header))
                    (clj->js {:name "loerun ipsum"})))
