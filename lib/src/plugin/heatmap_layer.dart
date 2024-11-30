/*
 * @Author: ZhouHongyi (leorexo@qq.com)
 * @Date: 2024-11-30 14:25:09
 * @LastEditTime: 2024-11-30 14:44:53
 * @FilePath: \fluttermap_heatmap\lib\src\plugin\heatmap_layer.dart
 * @Description: 
 * 
 * Copyright (c) 2024 by 环球信士(http://www.hqxs.net), All Rights Reserved. 
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';

class HeatMapLayer extends StatefulWidget {
  final HeatMapOptions heatMapOptions;
  final HeatMapDataSource heatMapDataSource;
  final Stream<void>? reset;

  HeatMapLayer(
      {super.key,
      HeatMapOptions? heatMapOptions,
      required this.heatMapDataSource,
      List<WeightedLatLng>? initialData,
      this.reset})
      : heatMapOptions = heatMapOptions ?? HeatMapOptions();

  @override
  State<StatefulWidget> createState() {
    return _HeatMapLayerState();
  }
}

class _HeatMapLayerState extends State<HeatMapLayer> {
  StreamSubscription<void>? _resetSub;

  /// As the reset stream no longer requests the new tile layers, only clears the
  /// cache, a pseudoUrl is generated every time a reset is requested
  late String pseudoUrl;

  @override
  void initState() {
    _regenerateUrl();

    if (widget.reset != null) {
      _resetSub = widget.reset?.listen((event) {
        setState(() {
          _regenerateUrl();
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _resetSub?.cancel();
    super.dispose();
  }

  void _regenerateUrl() {
    pseudoUrl = DateTime.now().microsecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.heatMapOptions.layerOpacity,
      child: TileLayer(
          backgroundColor: Colors.transparent,
          tileSize: 256,
          urlTemplate: pseudoUrl,
          tileProvider: HeatMapTilesProvider(
              heatMapOptions: widget.heatMapOptions,
              dataSource: widget.heatMapDataSource)),
    );
  }
}
