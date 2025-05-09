within IBPSA.Controls.OBC.Utilities.Validation;
model OptimalStartHeatingCooling
  "Validation model for the block OptimalStart for both heating and cooling system"
  IBPSA.Controls.OBC.Utilities.OptimalStart optSta(
    computeHeating=true,
    computeCooling=true)
    "Optimal start for both heating and cooling system"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Modelica.Blocks.Continuous.Integrator TRoo(
    k=0.0000004,
    y_start=19+273.15)
    "Room air temperature"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Constant TSetCooOcc(
    k=24+273.15)
    "Zone cooling setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Sin TOutBase(
    amplitude=5,
    freqHz=1/86400,
    offset=15+273.15,
    startTime(
      displayUnit="h")=0)
    "Outdoor dry bulb temperature, base component"
    annotation (Placement(transformation(extent={{-212,70},{-192,90}})));
  IBPSA.Controls.OBC.CDL.Reals.MultiplyByParameter UA(k=25)
    "Overall heat loss coefficient"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  IBPSA.Controls.OBC.CDL.Reals.Subtract dT
    "Temperature difference between zone and outdoor"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  IBPSA.Controls.OBC.CDL.Reals.MultiplyByParameter QCoo(k=-4000)
    "Heat extraction in the zone"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    realTrue=-6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  IBPSA.Controls.OBC.CDL.Reals.Add add1
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,0},{160,20}})));
  IBPSA.Controls.OBC.CDL.Reals.PID conPID1(
    controllerType=IBPSA.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=3,
    reverseActing=false)
    "PI control for space cooling"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));
  IBPSA.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{7,19},
    period=24*3600)
    "Daily schedule"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  IBPSA.Controls.OBC.CDL.Reals.MultiSum mulSum(
    nin=3)
    "Sum heat gains"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Constant TSetHeaOcc(
    k=21+273.15)
    "Zone heating setpoint during occupancy"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2(
    realTrue=6)
    "Convert Boolean to Real signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  IBPSA.Controls.OBC.CDL.Reals.Add add2
    "Reset temperature from unoccupied to occupied for optimal start period"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));
  IBPSA.Controls.OBC.CDL.Reals.PID conPID(
    controllerType=IBPSA.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=3)
    "PI control for space heating"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  IBPSA.Controls.OBC.CDL.Reals.MultiplyByParameter QHea(k=2000)
    "Heat injection in the zone"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  IBPSA.Controls.OBC.CDL.Reals.Add TOut
    "Outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-174,50},{-154,70}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    shift(
      displayUnit="d")=604800,
    amplitude=15,
    period(
      displayUnit="d")=1209600)
    "Range of outdoor dry bulb temperature"
    annotation (Placement(transformation(extent={{-214,30},{-194,50}})));
  IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal TSetHea(
    realTrue=273.15+21,
    realFalse=273.15+15,
    y(final unit="K",
      displayUnit="degC"))
    "Room temperature set point for heating"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal TSetCoo(
    realTrue=273.15+24,
    realFalse=273.15+30,
    y(final unit="K",
      displayUnit="degC"))
    "Room temperature set point for cooling"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

equation
  connect(dT.y,UA.u)
    annotation (Line(points={{-118,10},{-102,10}},color={0,0,127}));
  connect(TRoo.y,optSta.TZon)
    annotation (Line(points={{1,10},{10,10},{10,6},{38,6}},color={0,0,127}));
  connect(TSetCooOcc.y,optSta.TSetZonCoo)
    annotation (Line(points={{2,70},{10,70},{10,14},{38,14}},color={0,0,127}));
  connect(optSta.optOn,booToRea1.u)
    annotation (Line(points={{62,6},{70,6},{70,10},{78,10}},color={255,0,255}));
  connect(add1.y,conPID1.u_s)
    annotation (Line(points={{162,10},{178,10}},color={0,0,127}));
  connect(TRoo.y,conPID1.u_m)
    annotation (Line(points={{1,10},{6,10},{6,-6},{190,-6},{190,-2}},color={0,0,127}));
  connect(occSch.tNexOcc,optSta.tNexOcc)
    annotation (Line(points={{1,-44},{10,-44},{10,2},{38,2}},color={0,0,127}));
  connect(UA.y,mulSum.u[1])
    annotation (Line(points={{-78,10},{-70,10},{-70,11.3333},{-62,11.3333}},color={0,0,127}));
  connect(TRoo.u,mulSum.y)
    annotation (Line(points={{-22,10},{-38,10}},color={0,0,127}));
  connect(TSetHeaOcc.y,optSta.TSetZonHea)
    annotation (Line(points={{2,110},{14,110},{14,18},{38,18}},color={0,0,127}));
  connect(optSta.optOn,booToRea2.u)
    annotation (Line(points={{62,6},{70,6},{70,50},{78,50}},color={255,0,255}));
  connect(add2.y,conPID.u_s)
    annotation (Line(points={{162,50},{178,50}},color={0,0,127}));
  connect(conPID1.y,QCoo.u)
    annotation (Line(points={{202,10},{210,10},{210,-80},{-110,-80},{-110,-30},{-102,-30}},color={0,0,127}));
  connect(conPID.y,QHea.u)
    annotation (Line(points={{202,50},{212,50},{212,-130},{-108,-130},{-108,-100},{-102,-100}},color={0,0,127}));
  connect(QCoo.y,mulSum.u[2])
    annotation (Line(points={{-78,-30},{-70,-30},{-70,10},{-62,10}},color={0,0,127}));
  connect(QHea.y,mulSum.u[3])
    annotation (Line(points={{-78,-100},{-68,-100},{-68,8.66667},{-62,8.66667}},color={0,0,127}));
  connect(TOutBase.y,TOut.u1)
    annotation (Line(points={{-190,80},{-182,80},{-182,66},{-176,66}},    color={0,0,127}));
  connect(pul.y,TOut.u2)
    annotation (Line(points={{-192,40},{-180,40},{-180,54},{-176,54}},    color={0,0,127}));
  connect(TSetCoo.y,add1.u2)
    annotation (Line(points={{102,-30},{130,-30},{130,4},{138,4}},color={0,0,127}));
  connect(occSch.occupied,TSetCoo.u)
    annotation (Line(points={{1,-56},{60,-56},{60,-30},{78,-30}},color={255,0,255}));
  connect(TSetHea.u,occSch.occupied)
    annotation (Line(points={{78,-60},{60,-60},{60,-56},{1,-56}},color={255,0,255}));
  connect(booToRea1.y,add1.u1)
    annotation (Line(points={{102,10},{120,10},{120,16},{138,16}},color={0,0,127}));
  connect(booToRea2.y,add2.u1)
    annotation (Line(points={{102,50},{120,50},{120,56},{138,56}},color={0,0,127}));
  connect(TSetHea.y,add2.u2)
    annotation (Line(points={{102,-60},{126,-60},{126,44},{138,44}},color={0,0,127}));
  connect(TRoo.y, conPID.u_m) annotation (Line(points={{1,10},{6,10},{6,34},{190,
          34},{190,38}}, color={0,0,127}));
  connect(TOut.y, dT.u1) annotation (Line(points={{-152,60},{-146,60},{-146,16},
          {-142,16}}, color={0,0,127}));
  connect(TRoo.y, dT.u2) annotation (Line(points={{1,10},{6,10},{6,-6},{-146,-6},
          {-146,4},{-142,4}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=2419200,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/Utilities/Validation/OptimalStartHeatingCooling.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This models validates both space heating and cooling for the block
<a href=\"modelica://IBPSA.Controls.OBC.Utilities.OptimalStart\">
IBPSA.Controls.OBC.Utilities.OptimalStart</a>.
</p>
<p>
The first ten days is to test the heating case with a lower outdoor temperature.
The next ten days has a higher outdoor temprature, which is to test the cooling case.
The zone model has a time constant of 27.8 hours. The optimal start block converges separately
to an optimal start time for heating and cooling. Note that during the three transition
days, the zone temperature is in the deadband, so there is no need to optimally start
the heating or cooling system in advance.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 19, 2020, by Michael Wetter:<br/>
Simplified setpoint implementation.'
</li>
<li>
December 15, 2019, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-160},{220,160}})));
end OptimalStartHeatingCooling;
