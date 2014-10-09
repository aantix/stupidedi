require "rubygems"
require "set"
require "stupidedi"

# You can customize this to delegate to your own grammar definitions, if needed.
#config = Stupidedi::Config.default
config = Stupidedi::Config.new.customize do |c|
        c.interchange.customize do |x|
          x.register("00401") { Stupidedi::Versions::Interchanges::FourOhOne::InterchangeDef }
        end

        c.functional_group.customize do |x|
          x.register("004010") { Stupidedi::Versions::FunctionalGroups::FortyTen::FunctionalGroupDef }
        end

        c.transaction_set.customize do |x|
          x.register("004010", "SM", "204") { Stupidedi::Versions::FunctionalGroups::FortyTen::TransactionSetDefs::SM204 }

          x.register("004010X12", "SM", "204") { Stupidedi::Guides::FortyTen::X12::SM204  }
        end
end

b = Stupidedi::Builder::BuilderDsl.build(config)

b.ISA("00", "", "00", "", "ZZ", "111111111111111", "ZZ", "111111111111111", "990531", "1230", "U", "00401", "123456789", "0", "T", ">")
b. GS("SM", "SENDER ID", "RECEIVER ID", "19990531", "1230", "1", "X", "004010X12")
b. ST("204", "000010001")
  b. B2("RBTW", "12345678", "PP")
  b.B2A("00", "LT")
  b.L11("55455", "CO")
  b.L11("223456", "P8")
  b.G62("64", "20100528", "1", "1000")
  b.MS3("RBTW", "B", nil, "M")
  b.NTE("ZZZ", "THESE ARE HEADER NOTES")
  b.N1("BT", "BILL TO NAME", "ZZ", "12345")
  b.N3("BILL TO ADDRESS")
  b.N4("CITY", "ST", "ZIP", "USA")
  b.G61("CN", "TRACY", "TE", "555-666-4444")
  b. N7("123456", "FT")
  b. M7("777C8")
  b. S5("1", "CL")
  b.L11("111", "PO")
  b.L11("123456A1", "BM")
  b.G62("37", "20100530", "I", "1000")
  b.G62("38", "20100601", "K", "1000")
  b.NTE("ZZZ", "THIS IS A PICKUP NOTE")
  b. N1("SH", "PRIME", "ZZ", "1919")
  b. N3("501 WEST PARK ROAD", "LEETSDALE IND PARK")
  b. N4("LEETSDALE", "PA", "15056", "USA")
  b.G61("IC", "DAREN", "TE", "9999999999")
  b. L5("1", "OUTFITS, CLEANING STEAM", "222222", "N", "PLT")
  b.AT8("G", "L", "400000", "100", "5")
  b. S5("2", "CU")
  b.L11("111", "PO")
  b.L11("123456A1", "BM")
  b.G62("53", "20100602", "G", "0800")
  b.G62("54", "20100602", "L", "1500")
  b.NTE("ZZZ", "THIS IS A DELIVERY NOTE.")
  b. N1("CN", "FLORRY PRODUCTS, ENC.", "ZZ", "9898")
  b. N3("SCIOTO PARKWAY")
  b. N4("COLUMBUS", "OH", "43221", "USA")
  b.G61("IC", "DARCI", "TE", "2123433333")
  b. L5("1", "OUTFITS, CLEANING STEAM", "222222", "N", "PLT")
  b.AT8("G" , "L", "40000", "100", "5")
  b. L3("400000", "G")
b. SE("40", "000010001")
b. GE("1", "1")
b.IEA("1", "123456789")

b.machine.zipper.tap do |z|
  # The :component, and :repitition parameters can also be specified as elements
  # of the ISA segment, at `b.ISA(...)` above. When generating a document from
  # scratch, :segment and :element must be specified -- if you've parsed the doc
  # from a file, these params will default to whatever was used in the file, or
  # you can override them here.
  separators =
    Stupidedi::Reader::Separators.build(:segment    => "~\n",
                                        :element    => "*",
                                        :component  => ">",
                                        :repetition => "^")

  # You can also serialize any subtree within the document (e.g., everything inside
  # some ST..SE transaction set, or a single loop.
  w = Stupidedi::Writer::Default.new(z.root, separators)
  w.write($stdout)
end
