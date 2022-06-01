within IBPSA.Fluid.Chillers.BlackBoxData.BlackBox.BaseClasses;
partial model PartialBlackBox
  "Partial black box model of vapour compression cycles used for chiller applications"
  Modelica.Blocks.Interfaces.RealOutput Pel(final unit="W", final displayUnit="kW")
                                                      "Electrical Power consumed by HP" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,-110})));
  IBPSA.Fluid.Interfaces.VapourCompressionMachineControlBus sigBus
    "Bus-connector used in a chiller" annotation (Placement(
        transformation(
        extent={{-15,-14},{15,14}},
        rotation=0,
        origin={1,104})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final unit="W", final
      displayUnit="kW") "Heat flow rate through Evaporator" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,-110})));
protected
  parameter Real scalingFactor=1 "Scaling factor of chiller";

  annotation (Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),   Text(
          extent={{-57.5,-35},{57.5,35}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          textString="%name
",        origin={-3.5,-15},
          rotation=180)}));
end PartialBlackBox;