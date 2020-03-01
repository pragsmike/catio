(ns strung.world
  "Note that this namespace can run in either clojure or clojurescript runtime
  environment.")

(defn xy-range []
  (+ (rand-int 200)))

(defn velocity-range []
  (+ (rand-int 10)))

(defn color-generator []
  (.toString (rand-int 16rFFFFFF) 16))

(defn random-agent []
  {:x (xy-range)
   :y (xy-range)
   :vx (velocity-range)
   :vy (velocity-range)
   :c (color-generator)})

(defn agent-list []
  (for [i (range 5)]
    (random-agent)))

(defn init-world []
  (vec (agent-list)))

(defn add-agent [agents x y]
  (conj agents (-> (random-agent)
                   (assoc :x x)
                   (assoc :y y))))

(defn move
  "Given a single agent, returns that agent moved without constraint
  according to its current velocity and acceleration."
  [agent]
  (-> agent
      (update-in [:x] #(+ (:vx agent) %))
      (update-in [:y] #(+ (:vy agent) %))
      (update-in [:c] #(+ 10 %))))


(defn constrain
  "Given an agent, returns that agent possibly moved so as to satisfy
  constraints."
  [agent]
  (-> agent
      (update-in [:x] #(if (> % 200) 200 %))
      (update-in [:y] #(if (> % 200) 200 %))))


(defn bounce [agent]
  (if (>= (:x agent) 200)
    (update-in agent [:vx] -)
    (if (< (:x agent) 0)
      (update-in agent [:vx] -)
      (if (>= (:y agent) 200)
        (update-in agent [:vy] -)
        (if (< (:y agent) 0)
          (update-in agent [:vy] -)
        agent)))))


(defn evolve-one
  "Given a single agent, returns what that agent evolves into in the next
  timestep."
  [agent]
  (-> agent
      move
      bounce
      constrain))


(defn evolve [agents]
  (map evolve-one agents))

;;----------------------------------------------------------------------

(defn get-color [d] (str "#" (.toString d 16)))

(defn render-one* [i agent]
  (let [{:keys [x y c]} agent]
    [:rect {:x x
            :y y
            :width 5
            :height 5
            :fill (get-color c)}]))

(defn render-world [world]
  (map-indexed render-one* world))

