within IBPSA.Fluid.CHPs.OrganicRankine.Data.WorkingFluids;
record Toluene "Data record for toluene"
  extends Generic(
    T = {
         263.15,298.55,333.95,369.35,404.75,440.15,475.55,510.95,546.35,
         581.75},
    p = {
         4.658645382e+02,3.878506476e+03,1.913620075e+04,6.607278574e+04,
         1.775240880e+05,3.982149511e+05,7.826031771e+05,1.394511614e+06,
         2.312008822e+06,3.647284909e+06},
    rhoLiq = {
         894.591737923,861.787657162,828.382229573,793.747189122,
         757.123274828,717.4577212  ,673.073614045,620.835702655,
         553.321381336,437.838439728},
    dTRef = 30,
    sSatLiq = {
         -670.300584422,-462.345778557,-265.173474299, -75.486089983,
          108.735317728, 288.918011292, 466.37022759 , 642.81477669 ,
          821.684991655,1017.475208721},
    sSatVap = {
          978.30668321 , 919.722310325, 907.690979281, 926.229656023,
          964.682067033,1015.530364113,1072.870878952,1130.921098435,
         1181.095766989,1195.352192032},
    sRef = {
         1091.412085347,1033.610736055,1022.489953315,1042.016294547,
         1081.594543273,1133.917046387,1193.599794878,1256.201212851,
         1317.428314692,1372.739080272},
    hSatLiq = {
         -215928.299658583,-157558.83018377 , -95210.963812949,
          -28467.959306084,  42965.246838653, 119373.480365183,
          201168.191553062, 289147.81263614 , 385288.937285889,
          498520.557921947},
    hSatVap = {
         217902.702818657,255057.597752471,296467.120460337,
         341515.751482012,389409.693620114,439191.907459599,
         489589.576308111,538545.73773166 ,581653.014389845,
         602000.492963232},
    hRef = {
         249364.004857819,290767.909737456,336525.499214213,
         386015.721699957,438478.677428664,493067.399188192,
         548799.919772023,604412.858652115,658123.631255034,
         707533.724749596});
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "pro",
  Documentation(info="<html>
<p>
Record containing properties of toluene.
Its name in CoolProp is \"Toluene\".
A figure in the documentation of
<a href=\"Modelica://IBPSA.Fluid.CHPs.OrganicRankine.ConstantEvaporation\">
IBPSA.Fluid.CHPs.OrganicRankine.ConstantEvaporation</a>
shows which lines these arrays represent.
</p>
</html>"));
end Toluene;