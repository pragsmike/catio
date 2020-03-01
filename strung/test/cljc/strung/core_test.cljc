(ns strung.core-test
  (:require
   [cljs.test :refer [deftest is testing]]
   ))

; sample test
(deftest test-a
  (testing "a should be like b"
    (is (= 45 (reduce + (range 10))) "This should work")
    (is (= 45 (reduce + (range 10))))
    (is (= 45 (reduce + (range 10))))
    (is (= 45 (reduce + (range 10))))
    (is (= 45 (reduce + (range 10))))
    (is (= 45 (reduce + (range 10))))))





