within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions;
function wetterAfjei1997
  "Correction of COP (Icing, Defrost) according to Wetter, Afjei 1997"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor;
protected
  parameter Real offLin=0.03 "First factor for linear term, offset";
  parameter Real sloLin=-0.004 "Second factor for linear term, slope";
  parameter Real gauFac=0.1534 "Parameter for gaussian curve, factor";
  parameter Real gauMea=0.8869 "Parameter for gaussian curve, mean";
  parameter Real gauSig=26.06 "Parameter for gaussian curve, sigma";
  Real fac "Probability of icing";
  Real linTer "Linear part of equation";
  Real gauTer "Gaussian part of equation";
algorithm
  linTer :=offLin + sloLin*TEvaInMea;
  gauTer :=gauFac*Modelica.Math.exp(-(TEvaInMea - gauMea)*(TEvaInMea - gauMea)/
    gauSig);
  if linTer > 0 then
    fac := linTer + gauTer;
  else
    fac := gauTer;
  end if;
  iceFac:=1 - fac;
  annotation (Documentation(info="<html>
<p>
  Correction of the coefficient of performance due to 
  icing/frosting according to Wetter and Afjei 1997 
  (Dual stage compressor heat pump including frost and cycle losses, 
  <a href=\"https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf\">
  https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf</a>)
</p>
<p>
  For more information on the <code>iceFac</code>, see the documentation of <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
</p>
</html>",
  revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end wetterAfjei1997;