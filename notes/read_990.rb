require 'stupidedi'

def parse_990
  config = Stupidedi::Config.new.customize do |c|
    c.interchange.customize do |x|
      x.register("00401") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
    end

    c.functional_group.customize do |x|
      x.register("004010") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
    end

    c.transaction_set.customize do |x|
      x.register("004010", "SM", "204") { Stupidedi::Versions::FunctionalGroups::FortyTen::TransactionSetDefs::SM204 }
      x.register("004010", "GF", "990") { Stupidedi::Versions::FunctionalGroups::FortyTen::TransactionSetDefs::GF990 }

      x.register("004010", "SM", "204") { Stupidedi::Guides::FortyTen::X12::SM204  }
      x.register("004010", "GF", "990") { Stupidedi::Guides::FortyTen::X12::GF990  }
    end
  end

  b = Stupidedi::Builder::BuilderDsl.build(config, true)
end
