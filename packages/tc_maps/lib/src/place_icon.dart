import 'package:flutter/material.dart';
import 'package:tc_core/tc_core.dart';

/// Ícono para cada tipo de lugar.
IconData placeIcon(PlaceKind kind) => switch (kind) {
      PlaceKind.center => Icons.account_balance_rounded,
      PlaceKind.market => Icons.storefront_rounded,
      PlaceKind.health => Icons.local_hospital_rounded,
      PlaceKind.school => Icons.school_rounded,
      PlaceKind.transport => Icons.directions_bus_rounded,
      PlaceKind.sports => Icons.sports_soccer_rounded,
      PlaceKind.town => Icons.holiday_village_rounded,
      PlaceKind.home => Icons.home_rounded,
      PlaceKind.pin => Icons.place_rounded,
    };
