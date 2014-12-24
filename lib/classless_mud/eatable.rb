module ClasslessMud
  class Eatable < Item
    property :health_effect, Integer
    property :effect_description, String

    def edible?
      true
    end
  end
end
