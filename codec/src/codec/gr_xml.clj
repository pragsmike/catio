(ns codec.gr-xml
  (:require [clojure.xml :as xml]))


(defn grc-meta [grc]
  (->> grc
      :content
      first
      ((juxt :tag :content))
      ((fn [[k v]] [k (first v)]))
      (apply hash-map)
      ))



(defn tagged->semantic [tag-content-pairs]
  (map (juxt :tag :content) tag-content-pairs)
  )
(defn dosub [kv-pair]
  (case (first kv-pair)
    :param (let [[kp vp] (tagged->semantic (second kv-pair))]
             [ (keyword (first (second kp))) (first (second vp))]
             )
    :key  [ :key (first (second kv-pair))]
    kv-pair
    )
  )
(defn dosubs [kv-pairs]
  (into (sorted-map)
        (map dosub kv-pairs))
  )


(defn grc-blocks [grc]
  (->> grc
       :content
       (filter #(= :block (:tag %)))
       (map :content)
       (map tagged->semantic)
       (map dosubs)
       ))

(defn grc-block-layout [grc-block]
  (select-keys grc-block [:_coordinate :_enabled :_rotation
                          :author :category :comment :description
                          :id :key :qt_qss_theme :title :window_size]))

(defn grc-layout [grc]
  (map grc-block-layout (grc-blocks grc)))

(comment
  (def grc (clojure.xml/parse "test/two.grc"))
  )

