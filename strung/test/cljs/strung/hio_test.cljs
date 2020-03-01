(ns strung.hio-test
  (:require
   [cljs.test :refer [deftest is testing]]
   [strung.hio :refer [jstr->clj decode zlib-header deflate byte-seq->string]]
   #_[fs]
   ))

(defn sample-homotopy-json []
  #_(fs/readFileSync "test/homotopy.io.json"))

(defn sample-proof-base64 []
  (let [s (sample-homotopy-json)
        c (jstr->clj s)]
    (:proof c)))

(defn sample-proof-compressed []
  (let [p (sample-proof-base64)]
    (decode p)))

(deftest test-jstr->clj
  (testing "parse"
    (is (= {} (jstr->clj "{}")))
    (let [s (sample-homotopy-json)
          c (jstr->clj s)]
      (is (= 2 (count (keys c)) ))
      (is (= [:metadata :proof] (keys c) )))))

(deftest test-decode
  (let [p (sample-proof-base64)
        b (decode p)]
    (is (string? p))
    (is (= 700 (count p)))
    ))

(deftest test-deflate
  #_(let [p (sample-proof-base64)
        b (decode p)
        u (deflate b)]
    (is (string? p))
    (is (= 700 (count p)))
    (is (vector? zlib-header))
    (is (= 8 (count zlib-header)))
    (is (= 523 (count b)))
    (is (= nil u))
    (is (= nil (byte-seq->string u)))
    )
  )
