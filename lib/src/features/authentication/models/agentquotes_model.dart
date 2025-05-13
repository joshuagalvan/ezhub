class AgentQuotes {
  dynamic id;
  dynamic created_date;
  dynamic name;
  dynamic email;
  dynamic branch;
  dynamic toc;
  dynamic rate;
  dynamic year;
  dynamic carCompany;
  dynamic carMake;
  dynamic carType;
  dynamic carVariant;
  dynamic fmv;
  dynamic deductible;
  dynamic totalpremium;
  dynamic basicPremium;
  dynamic docStamp;
  dynamic vat;
  dynamic localTax;
  dynamic od;
  dynamic theft;
  dynamic aon;

  AgentQuotes(
      {this.id,
      this.created_date,
      this.name,
      this.email,
      this.branch,
      this.toc,
      this.rate,
      this.year,
      this.carCompany,
      this.carMake,
      this.carType,
      this.carVariant,
      this.fmv,
      this.deductible,
      this.totalpremium,
      this.basicPremium,
      this.docStamp,
      this.vat,
      this.localTax,
      this.od,
      this.theft,
      this.aon});

  AgentQuotes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    created_date = json['created_date'];
    name = json['name'];
    email = json['email'];
    branch = json['branch'];
    toc = json['toc'];
    rate = json['rate'];
    year = json['year'];
    carCompany = json['carCompany'];
    carMake = json['carMake'];
    carType = json['carType'];
    carVariant = json['carVariant'];
    fmv = json['fmv'];
    deductible = json['deductible'];
    totalpremium = json['totalpremium'];
    basicPremium = json['basicPremium'];
    docStamp = json['docStamp'];
    vat = json['vat'];
    localTax = json['localTax'];
    od = json['od'];
    theft = json['theft'];
    aon = json['aon'];
  }
}
