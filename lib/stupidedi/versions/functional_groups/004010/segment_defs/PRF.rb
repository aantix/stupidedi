module Stupidedi
  module Versions
    module FunctionalGroups
      module FortyTen
        module SegmentDefs

          s = Schema
          e = ElementDefs
          r = ElementReqs

        # Definition might be outdated, working from ANSI X12 2001 specification

          PRF = s::SegmentDef.build(:PRF, "Purchase Order Reference",
            "To specify line-item purchase order",
            e::E324 .simple_use(r::Mandatory,   s::RepeatCount.bounded(1)),
            e::E328 .simple_use(r::Optional,  s::RepeatCount.bounded(1)))
        end
      end
    end
  end
end
