(ns strung.events
  ""
  (:require [cljs.core.async :as a :refer (chan timeout)]
            [re-frame.core :as rf]
            [strung.edit :as edit]
            [strung.world :as pop]))


(rf/reg-event-db
 :initialize
 (fn [_ _] {:current-view :sim
            :world (pop/init-world)
            :tick-number 0
            :running false
            :editor-tool :rect
            }))


(rf/reg-event-fx
 :editor-ui
 edit/ui-events-handler)

(rf/reg-event-fx
 :editor
 edit/editor-events-handler)

(rf/reg-event-db
 :switch-to-view
 (fn [db [_ new-view]]
   (assoc db :current-view new-view)))

(rf/reg-event-db
 :sim
 (fn [db [_ cmd]]
   (case cmd
     :start (assoc db :running (not (:running db)))
     :reset (assoc db :world (pop/init-world))
     :single (assoc db :world (pop/evolve (:world db))))
   ))

