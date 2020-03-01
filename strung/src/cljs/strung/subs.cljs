(ns strung.subs
  ""
  (:require [reagent.core :as reagent :refer [atom]]
            [re-frame.core :as rf]
            [strung.world :as pop]))
(rf/reg-sub
 :current-view
 (fn [db _]
   (:current-view db)))

(rf/reg-sub
 :world
 (fn [db _]
   (:world db)))

(rf/reg-sub
 :running
 (fn [db _]
   (:running db)))

(rf/reg-sub
 :editor-tool
 (fn [db _]
   (:editor-tool db)))
