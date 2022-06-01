﻿within IBPSA.Fluid.HeatPumps.BaseClasses;
partial model PartialReversibleVapourCompressionMachine
  "Grey-box model for reversible heat pumps and chillers using a black-box to simulate the vapour compression cycle"
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium_con,
    redeclare final package Medium2 = Medium_eva,
    final m1_flow_nominal=mCon_flow_nominal_final,
    final m2_flow_nominal=mEva_flow_nominal_final,
    final allowFlowReversal1=allowFlowReversalCon,
    final allowFlowReversal2=allowFlowReversalEva,
    final m1_flow_small=1E-4*abs(mCon_flow_nominal_final),
    final m2_flow_small=1E-4*abs(mEva_flow_nominal_final));

//General
  replaceable package Medium_con =
    Modelica.Media.Interfaces.PartialMedium "Medium at sink side"
    annotation (Dialog(tab = "Condenser"),choicesAllMatching=true);
  replaceable package Medium_eva =
    Modelica.Media.Interfaces.PartialMedium "Medium at source side"
    annotation (Dialog(tab = "Evaporator"),choicesAllMatching=true);
  replaceable IBPSA.Fluid.HeatPumps.BaseClasses.PartialInnerCycle innerCycle
    constrainedby IBPSA.Fluid.HeatPumps.BaseClasses.PartialInnerCycle
    "Blackbox model of refrigerant cycle of a vapour compression machine"
    annotation (Placement(transformation(extent={{-18,-18},{18,18}}, rotation=90)));
  replaceable model vapComIne =
      HeatPumps.BlackBoxData.VapourCompressionInertias.BaseClasses.PartialInertia
    constrainedby
    HeatPumps.BlackBoxData.VapourCompressionInertias.BaseClasses.PartialInertia
                                                                       "Model for the inertia between the stationary black box data outputs and the inputs into the heat exchangers."
    annotation (choicesAllMatching=true, Dialog(group="Inertia"));
  parameter Boolean use_rev=true "Is the vapour compression machine reversible?"   annotation(choices(checkBox=true), Dialog(descriptionLabel=true));
  parameter Boolean use_autoCalc=false
    "Enable automatic estimation of volumes and mass flows?"
    annotation(choices(checkBox=true), Dialog(descriptionLabel=true));
  parameter Modelica.Units.SI.Power Q_useNominal(start=0)
    "Nominal usable heat flow of the vapour compression machine (HP: Heating; Chiller: Cooling)"
    annotation (Dialog(enable=use_autoCalc));
  parameter Real scalingFactor=1 "Scaling-factor of vapour compression machine";

  parameter Boolean use_busConnectorOnly=false
    "=true to use bus connector for model inputs (modeSet, ySet, TSet, onOffSet). =false to use the bus connector for outputs only."
    annotation(choices(checkBox=true), Dialog(group="Input Connectors"));
  parameter Boolean use_TSet=false
    "=true to use black-box internal control for supply temperature of device with the given temperature set point TSet"
    annotation(choices(checkBox=true), Dialog(group="Input Connectors"));

//Condenser
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Manual input of the nominal mass flow rate (if not automatically calculated)"
    annotation (Dialog(
      group="Parameters",
      tab="Condenser",
      enable=not use_autoCalc), Evaluate=true);
  parameter Modelica.Units.SI.Volume VCon
    "Manual input of the condenser volume (if not automatically calculated)"
    annotation (Evaluate=true, Dialog(
      group="Parameters",
      tab="Condenser",
      enable=not use_autoCalc));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal
    "Pressure drop at nominal mass flow rate" annotation (Dialog(group="Flow resistance",
        tab="Condenser"), Evaluate=true);
  parameter Real deltaM_con=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Condenser", group="Flow resistance"));
  parameter Boolean use_conCap=true
    "If heat losses at capacitor side are considered or not"
    annotation (Dialog(group="Heat Losses", tab="Condenser"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CCon
    "Heat capacity of Condenser (= cp*m). If you want to neglace the dry mass of the condenser, you can set this value to zero"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConOut
    "Constant parameter for heat transfer to the ambient. Represents a sum of thermal resistances such as conductance, insulation and natural convection. If you want to simulate a condenser with additional dry mass but without external heat losses, set the value to zero"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConIns
    "Constant parameter for heat transfer to heat exchangers capacity. Represents a sum of thermal resistances such as forced convection and conduction inside of the capacity"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
//Evaporator
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Manual input of the nominal mass flow rate (if not automatically calculated)"
    annotation (Dialog(
      group="Parameters",
      tab="Evaporator",
      enable=not use_autoCalc), Evaluate=true);
  parameter Modelica.Units.SI.Volume VEva
    "Manual input of the evaporator volume (if not automatically calculated)"
    annotation (Evaluate=true, Dialog(
      group="Parameters",
      tab="Evaporator",
      enable=not use_autoCalc));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal
    "Pressure drop at nominal mass flow rate" annotation (Dialog(group="Flow resistance",
        tab="Evaporator"), Evaluate=true);
  parameter Real deltaM_eva=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Evaporator", group="Flow resistance"));
  parameter Boolean use_evaCap=true
    "If heat losses at capacitor side are considered or not"
    annotation (Dialog(group="Heat Losses", tab="Evaporator"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CEva
    "Heat capacity of Evaporator (= cp*m). If you want to neglace the dry mass of the evaporator, you can set this value to zero"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaOut
    "Constant parameter for heat transfer to the ambient. Represents a sum of thermal resistances such as conductance, insulation and natural convection. If you want to simulate a evaporator with additional dry mass but without external heat losses, set the value to zero"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaIns
    "Constant parameter for heat transfer to heat exchangers capacity. Represents a sum of thermal resistances such as forced convection and conduction inside of the capacity"
    annotation (Evaluate=true, Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
//Assumptions
  parameter Boolean allowFlowReversalEva=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Evaporator", tab="Assumptions"));
  parameter Boolean allowFlowReversalCon=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Condenser", tab="Assumptions"));

//Initialization
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation (Dialog(tab="Initialization", group="Parameters"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pCon_start=
      Medium_con.p_default "Start value of pressure"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.Temperature TCon_start=Medium_con.T_default
    "Start value of temperature"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Units.SI.Temperature TConCap_start=Medium_con.T_default
    "Initial temperature of heat capacity of condenser" annotation (Dialog(
      tab="Initialization",
      group="Condenser",
      enable=use_conCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XCon_start[Medium_con.nX]=
     Medium_con.X_default "Start value of mass fractions m_i/m"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pEva_start=
      Medium_eva.p_default "Start value of pressure"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Media.Interfaces.Types.Temperature TEva_start=Medium_eva.T_default
    "Start value of temperature"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Units.SI.Temperature TEvaCap_start=Medium_eva.T_default
    "Initial temperature of heat capacity at evaporator" annotation (Dialog(
      tab="Initialization",
      group="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XEva_start[Medium_eva.nX]=
     Medium_eva.X_default "Start value of mass fractions m_i/m"
    annotation (Evaluate=true,Dialog(tab="Initialization", group="Evaporator"));

//Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state (only affects fluid-models)"
    annotation (Dialog(tab="Dynamics", group="Equation"));
//Advanced
  parameter Boolean machineType "=true if heat pump; =false if chiller"
    annotation (Dialog(tab="Advanced", group="General machine information"));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Real ySet_small=0.01
    "Value of ySet at which the device is considered turned on. Default is 1 % as heat pumps and chillers currently invert down to 15 %."
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity con(
    redeclare final package Medium = Medium_con,
    final allowFlowReversal=allowFlowReversalCon,
    final m_flow_small=1E-4*abs(mCon_flow_nominal_final),
    final show_T=show_T,
    final deltaM=deltaM_con,
    final T_start=TCon_start,
    final p_start=pCon_start,
    final use_cap=use_conCap,
    final X_start=XCon_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final is_con=true,
    final V=VCon_final*scalingFactor,
    final C=CCon*scalingFactor,
    final TCap_start=TConCap_start,
    final GOut=GConOut*scalingFactor,
    final m_flow_nominal=mCon_flow_nominal_final*scalingFactor,
    final dp_nominal=dpCon_nominal*scalingFactor,
    final GInn=GConIns*scalingFactor) "Heat exchanger model for the condenser"
    annotation (Placement(transformation(extent={{-20,72},{20,112}})));
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity eva(
    redeclare final package Medium = Medium_eva,
    final deltaM=deltaM_eva,
    final use_cap=use_evaCap,
    final allowFlowReversal=allowFlowReversalEva,
    final m_flow_small=1E-4*abs(mEva_flow_nominal_final),
    final show_T=show_T,
    final T_start=TEva_start,
    final p_start=pEva_start,
    final X_start=XEva_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final is_con=false,
    final V=VEva_final*scalingFactor,
    final C=CEva*scalingFactor,
    final m_flow_nominal=mEva_flow_nominal_final*scalingFactor,
    final dp_nominal=dpEva_nominal*scalingFactor,
    final TCap_start=TEvaCap_start,
    final GOut=GEvaOut*scalingFactor,
    final GInn=GEvaIns*scalingFactor) "Heat exchanger model for the evaporator"
    annotation (Placement(transformation(extent={{20,-72},{-20,-112}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTempOutEva
 if use_evaCap "Foreces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTempOutCon
 if use_conCap "Foreces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,110})));

  Modelica.Blocks.Interfaces.RealInput ySet
    if not use_busConnectorOnly and not use_TSet
    "Input signal speed for compressor relative between 0 and 1" annotation (Placement(
        transformation(extent={{-132,4},{-100,36}})));
  Interfaces.VapourCompressionMachineControlBus                sigBus annotation (
      Placement(transformation(extent={{-120,-60},{-90,-26}}),
        iconTransformation(extent={{-108,-52},{-90,-26}})));

  Modelica.Blocks.Interfaces.RealInput TEvaAmb(final unit="K", final
      displayUnit="degC") if use_evaCap and not use_busConnectorOnly
    "Ambient temperature on the evaporator side" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-100})));
  Modelica.Blocks.Interfaces.RealInput TConAmb(final unit="K", final
      displayUnit="degC") if use_conCap and not use_busConnectorOnly
    "Ambient temperature on the condenser side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={110,100})));

  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", final
      displayUnit="degC")
    if not use_busConnectorOnly and use_TSet
    "Input signal temperature for internal control"
    annotation (Placement(transformation(extent={{-132,24},{-100,56}})));
  Modelica.Blocks.Interfaces.BooleanInput onOffSet
    if not use_busConnectorOnly and use_TSet
    "Set value of operation mode if internal temperature control is used"
    annotation (Placement(transformation(extent={{-132,-36},{-100,-4}})));
  Modelica.Blocks.Interfaces.BooleanInput modeSet
    if not use_busConnectorOnly and use_rev
    "Set value of operation mode"
    annotation (Placement(transformation(extent={{-132,-106},{-100,-74}})));

  IBPSA.Fluid.Sensors.MassFlowRate mFlow_eva(redeclare final package Medium =
        Medium_eva, final allowFlowReversal=allowFlowReversalEva)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={72,-60},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  IBPSA.Fluid.Sensors.MassFlowRate mFlow_con(final allowFlowReversal=
        allowFlowReversalEva, redeclare final package Medium = Medium_con)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={-50,92},
        extent={{-10,10},{10,-10}},
        rotation=0)));

  //Automatic calculation of mass flow rates and volumes of the evaporator and condenser using linear regressions from data sheets of heat pumps and chillers (water to water)

  Modelica.Blocks.Logical.Hysteresis hysteresis(
    final uLow=Modelica.Constants.eps,
    final uHigh=ySet_small,
    final pre_y_start=false) "Use default ySet value" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,-30})));

  vapComIne vapComIneCon "Inertia model for condenser side"
                         annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  vapComIne vapComIneEva "Inertia model for evaporator side"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50})));

  SenTempInflow senTConIn(y=Medium_con.temperature(Medium_con.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow))))
    "Real expression for condenser inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,90})));
  SenTempInflow senTEvaIn(y=Medium_eva.temperature(Medium_eva.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow))))
    "Real expression for evaporator inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-40})));
protected
  parameter Modelica.Units.SI.MassFlowRate autoCalc_mMin_flow=0.3
    "Realistic mass flow minimum for simulation plausibility";
  parameter Modelica.Units.SI.Volume autoCalc_VMin=0.003
    "Realistic volume minimum for simulation plausibility";

  parameter Modelica.Units.SI.MassFlowRate autoCalc_mEva_flow=if machineType
       then max(0.00004*Q_useNominal - 0.3177, autoCalc_mMin_flow) else max(0.00005
      *Q_useNominal - 0.5662, autoCalc_mMin_flow);
  parameter Modelica.Units.SI.MassFlowRate autoCalc_mCon_flow=if machineType
       then max(0.00004*Q_useNominal - 0.6162, autoCalc_mMin_flow) else max(0.00005
      *Q_useNominal + 0.3161, autoCalc_mMin_flow);
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal_final=if
      use_autoCalc then autoCalc_mEva_flow else mEva_flow_nominal;
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal_final=if
      use_autoCalc then autoCalc_mCon_flow else mCon_flow_nominal;
  parameter Modelica.Units.SI.Volume autoCalc_VEva=if machineType then max(0.0000001
      *Q_useNominal - 0.0075,autoCalc_VMin)  else max(0.0000001*Q_useNominal - 0.0066,
      autoCalc_VMin);
  parameter Modelica.Units.SI.Volume autoCalc_VCon=if machineType then max(0.0000001
      *Q_useNominal - 0.0094,autoCalc_VMin)  else max(0.0000002*Q_useNominal - 0.0084,
      autoCalc_VMin);
  parameter Modelica.Units.SI.Volume VEva_final=if use_autoCalc then
      autoCalc_VEva else VEva;
  parameter Modelica.Units.SI.Volume VCon_final=if use_autoCalc then
      autoCalc_VCon else VCon;

equation
  //Control and feedback for the auto-calculation of condenser and evaporator data
  assert(not use_autoCalc or (use_autoCalc and Q_useNominal>0), "Can't auto-calculate evaporator and condenser data without a given nominal power flow (Q_useNominal)!",
  level = AssertionLevel.error);
  assert(
    not use_autoCalc or (autoCalc_mEva_flow > autoCalc_mMin_flow and
      autoCalc_mEva_flow < 90),
    "Given nominal power (Q_useNominal) for auto-calculation of evaporator and condenser data is outside the range of data sheets considered. Please control the auto-calculated mass flows!",
    level=AssertionLevel.warning);
  assert(not use_autoCalc or (autoCalc_VEva>autoCalc_VMin and autoCalc_VEva<0.43),
  "Given nominal power (Q_useNominal) for auto-calculation of evaporator and condenser data is outside the range of data sheets considered. Please control the auto-calculated volumes!",
  level = AssertionLevel.warning);

  connect(mFlow_eva.m_flow, sigBus.m_flowEvaMea) annotation (Line(points={{72,-49},
          {72,-40},{26,-40},{26,-30},{-30,-30},{-30,-52},{-76,-52},{-76,-43},{-105,
          -43}},                                                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mFlow_con.m_flow, sigBus.m_flowConMea) annotation (Line(points={{-50,81},
          {-50,32},{-76,32},{-76,-43},{-105,-43}},
                                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));

  connect(innerCycle.sigBus, sigBus) annotation (Line(
      points={{-18.54,0.18},{-30,0.18},{-30,-52},{-76,-52},{-76,-43},{-105,-43}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(innerCycle.Pel, sigBus.PelMea) annotation (Line(points={{19.89,0.09},{
          26,0.09},{26,-30},{-30,-30},{-30,-52},{-76,-52},{-76,-43},{-105,-43}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(modeSet, sigBus.modeSet) annotation (Line(points={{-116,-90},{-76,-90},
          {-76,-43},{-105,-43}},        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ySet,sigBus.ySet)  annotation (Line(points={{-116,20},{-76,20},{-76,-43},
          {-105,-43}},         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TConAmb, varTempOutCon.T) annotation (Line(
      points={{110,100},{88,100},{88,110},{82,110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(varTempOutCon.port, con.port_out) annotation (Line(
      points={{60,110},{40,110},{40,118},{0,118},{0,112}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(TEvaAmb, varTempOutEva.T) annotation (Line(
      points={{110,-100},{82,-100}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(eva.port_out, varTempOutEva.port) annotation (Line(
      points={{0,-112},{0,-118},{54,-118},{54,-100},{60,-100}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(port_b2, port_b2) annotation (Line(points={{-100,-60},{-100,-60},{-100,
          -60}}, color={0,127,255}));
  connect(mFlow_eva.port_a, port_a2)
    annotation (Line(points={{82,-60},{100,-60}}, color={0,127,255}));
  connect(port_a1, mFlow_con.port_a)
    annotation (Line(points={{-100,60},{-68,60},{-68,92},{-60,92}},
                                                  color={0,127,255}));
  connect(hysteresis.y, sigBus.onOffMea) annotation (Line(points={{-39,-30},{-30,
          -30},{-30,-52},{-76,-52},{-76,-43},{-105,-43}},
                                      color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(varTempOutCon.T, sigBus.TConAmbMea) annotation (Line(
      points={{82,110},{88,110},{88,82},{38,82},{38,32},{-76,32},{-76,-43},{-105,
          -43}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(varTempOutEva.T, sigBus.TEvaAmbMea) annotation (Line(
      points={{82,-100},{88,-100},{88,-118},{-76,-118},{-76,-43},{-105,-43}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysteresis.u, sigBus.ySet) annotation (Line(points={{-62,-30},{-76,-30},
          {-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(innerCycle.QEva_flow, vapComIneEva.u) annotation (Line(points={{-1.22125e-15,
          -19.8},{-1.22125e-15,-28.9},{2.22045e-15,-28.9},{2.22045e-15,-38}},
        color={0,0,127}));
  connect(eva.QFlow_in, vapComIneEva.y) annotation (Line(points={{2.22045e-16,-70.8},
          {2.22045e-16,-65.9},{-1.9984e-15,-65.9},{-1.9984e-15,-61}},
        color={0,0,127}));
  connect(vapComIneCon.y, con.QFlow_in) annotation (Line(points={{7.21645e-16,61},
          {7.21645e-16,69.9},{-2.22045e-16,69.9},{-2.22045e-16,70.8}},    color=
         {0,0,127}));
  connect(vapComIneCon.u, innerCycle.QCon_flow) annotation (Line(points={{-6.66134e-16,
          38},{-6.66134e-16,28.9},{1.22125e-15,28.9},{1.22125e-15,19.8}}, color=
         {0,0,127}));
  connect(onOffSet, sigBus.onOffSet) annotation (Line(points={{-116,-20},{-76,
          -20},{-76,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(con.T, sigBus.TConOutMea) annotation (Line(points={{22.4,82},{38,82},{
          38,32},{-76,32},{-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.port_b, port_b1) annotation (Line(points={{20,92},{78,92},{78,60},
          {100,60}}, color={0,127,255}));
  connect(senTConIn.y, sigBus.TConInMea) annotation (Line(points={{-79,90},{-72,
          90},{-72,32},{-76,32},{-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mFlow_con.port_b, con.port_a)
    annotation (Line(points={{-40,92},{-20,92}}, color={0,127,255}));
  connect(eva.T, sigBus.TEvaOutMea) annotation (Line(points={{-22.4,-82},{-76,-82},
          {-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTEvaIn.y, sigBus.TEvaInMea) annotation (Line(points={{79,-40},{26,-40},
          {26,-30},{-30,-30},{-30,-52},{-76,-52},{-76,-43},{-105,-43}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(mFlow_eva.port_b, eva.port_a) annotation (Line(points={{62,-60},{32,-60},
          {32,-92},{20,-92}}, color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-20,-92},{-70,-92},{-70,
          -60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(extent={{-100,-120},{100,120}}), graphics={
        Rectangle(
          extent={{-16,83},{16,-83}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,-64},
          rotation=90),
        Rectangle(
          extent={{-17,83},{17,-83}},
          fillColor={255,0,128},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,61},
          rotation=90),
        Text(
          extent={{-76,6},{74,-36}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="%name
"),     Line(
          points={{-9,40},{9,40},{-5,-2},{9,-40},{-9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-3,-60},
          rotation=-90),
        Line(
          points={{9,40},{-9,40},{5,-2},{-9,-40},{9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-5,56},
          rotation=-90),
        Rectangle(
          extent={{-82,42},{84,-46}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,60},{88,60}}, color={28,108,200}),
        Line(points={{-88,-60},{88,-60}}, color={28,108,200}),
    Line(
    origin={-75.5,-80.333},
    points={{43.5,8.3333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,-11.667},{27.5,-21.667},{13.5,-23.667},
              {11.5,-31.667}},
      smooth=Smooth.Bezier,
      visible=use_evaCap),
        Polygon(
          points={{-70,-122},{-68,-108},{-58,-114},{-70,-122}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_evaCap),
    Line( origin={40.5,93.667},
          points={{39.5,6.333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,
              -11.667},{27.5,-21.667},{13.5,-23.667},{11.5,-27.667}},
          smooth=Smooth.Bezier,
          visible=use_conCap),
        Polygon(
          points={{86,110},{84,96},{74,102},{86,110}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_conCap),
        Line(
          points={{-42,72},{34,72}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5),
        Line(
          points={{-38,0},{38,0}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5,
          origin={0,-74},
          rotation=180)}),                Diagram(coordinateSystem(extent={{-100,
            -120},{100,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This partial model for a generic grey-box vapour compression machine
  (heat pump or chiller) uses empirical data to model the refrigerant
  cycle. The modelling of system inertias and heat losses allow the
  simulation of transient states.
</p>
<p>
  Resulting in the choosen model structure, several configurations are
  possible:
</p>
<ol>
  <li>Compressor type: on/off or inverter controlled
  </li>
  <li>Reversible operation / only main operation
  </li>
  <li>Source/Sink: Any combination of mediums is possible
  </li>
  <li>Generik: Losses and inertias can be switched on or off.
  </li>
</ol>
<h4>
  Concept
</h4>
<p>
  Using a signal bus as a connector, this model working as a heat pump
  can be easily combined with several control or safety blocks from
  <a href=
  \"modelica://IBPSA.Controls.HeatPump\">IBPSA.Controls.HeatPump</a>.
  The relevant data is aggregated. In order to control both chillers
  and heat pumps, both flow and return temperature are aggregated. The
  mode signal chooses the operation type of the vapour compression
  machine:
</p>
<ul>
  <li>mode = true: Main operation mode (heat pump: heating; chiller:
  cooling)
  </li>
  <li>mode = false: Reversible operation mode (heat pump: cooling;
  chiller: heating)
  </li>
</ul>
<p>
  To model both on/off and inverter controlled vapour compression
  machines, the compressor speed is normalizd to a relative value
  between 0 and 1.
</p>
<p>
  Possible icing of the evaporator is modelled with an input value
  between 0 and 1.
</p>
<p>
  The model structure is as follows. To understand each submodel,
  please have a look at the corresponding model information:
</p>
<ol>
  <li>
    <a href=
    \"IBPSA.Fluid.HeatPumps.BaseClasses.InnerCycle\">InnerCycle</a>
    (Black Box): Here, the user can use between several input models or
    just easily create his own, modular black box model. Please look at
    the model description for more info.
  </li>
  <li>Inertia: A n-order element is used to model system inertias (mass
  and thermal) of components inside the refrigerant cycle (compressor,
  pipes, expansion valve)
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity\">
    HeatExchanger</a>: This new model also enable modelling of thermal
    interias and heat losses in a heat exchanger. Please look at the
    model description for more info.
  </li>
</ol>
<h4>
  Parametrization
</h4>
<p>
  To simplify the parametrization of the evaporator and condenser
  volumes and nominal mass flows there exists an option of automatic
  estimation based on the nominal usable power of the vapour
  compression machine. This function uses a linear correlation of these
  parameters, which was established from the linear regression of more
  than 20 data sets of water-to-water heat pumps from different
  manufacturers (e.g. Carrier, Trane, Lennox) ranging from about 25kW
  to 1MW nominal power. The linear regressions with coefficients of
  determination above 91% give a good approximation of these
  parameters. Nevertheless, estimates for machines outside the given
  range should be checked for plausibility during simulation.
</p>
<h4>
  Assumptions
</h4>
<p>
  Several assumptions where made in order to model the vapour
  compression machine. For a detailed description see the corresponding
  model.
</p>
<ol>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.LookUpTable2D\">
    Performance data 2D</a>: In order to model inverter controlled
    machines, the compressor speed is scaled <b>linearly</b>
  </li>
  <li>
    <a href=
    \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData.LookUpTable2D\">
    Performance data 2D</a>: Reduced evaporator power as a result of
    icing. The icing factor is multiplied with the evaporator power.
  </li>
  <li>
    <b>Inertia</b>: The default value of the n-th order element is set
    to 3. This follows comparisons with experimental data. Previous
    heat pump models are using n = 1 as a default. However, it was
    pointed out that a higher order element fits a real heat pump
    better in
  </li>
  <li>
    <b>Scaling factor</b>: A scaling facor is implemented for scaling
    of the thermal power and capacity. The factor scales the parameters
    V, m_flow_nominal, C, GIns, GOut and dp_nominal. As a result, the
    vapour compression machine can supply more heat with the COP
    staying nearly constant. However, one has to make sure that the
    supplied pressure difference or mass flow is also scaled with this
    factor, as the nominal values do not increase said mass flow.
  </li>
</ol>
<h4>
  Known Limitations
</h4>
<ul>
  <li>The n-th order element has a big influence on computational time.
  Reducing the order or disabling it completly will decrease
  computational time.
  </li>
  <li>Reversing the mode: A normal 4-way-exchange valve suffers from
  heat losses and irreversibilities due to switching from one mode to
  another. Theses losses are not taken into account.
  </li>
</ul>
</html>"));
end PartialReversibleVapourCompressionMachine;