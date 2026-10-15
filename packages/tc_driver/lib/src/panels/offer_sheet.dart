import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tc_core/tc_core.dart';
import 'package:tc_design_system/tc_design_system.dart';

import '../driver_providers.dart';

/// Oferta de viaje: entra desde abajo sobre un velo, con cuenta regresiva.
/// Lo más importante, en orden: cuánto paga, dónde recoge, a dónde va y quién es.
class OfferSheet extends ConsumerStatefulWidget {
  const OfferSheet({super.key, required this.offer, required this.driverPosition});

  final Trip offer;
  final LatLng driverPosition;

  @override
  ConsumerState<OfferSheet> createState() => _OfferSheetState();
}

class _OfferSheetState extends ConsumerState<OfferSheet> with SingleTickerProviderStateMixin {
  late final _enter = AnimationController(vsync: this, duration: TcMotion.slow);
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (TcMotion.reduced(context)) {
      _enter.value = 1;
    } else if (_enter.value == 0) {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  Future<void> _respond({required bool accept}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final repo = ref.read(tripRepositoryProvider);
    final driverId = ref.read(driverProfileProvider).id;
    if (accept) {
      await repo.acceptOffer(driverId, widget.offer.id);
    } else {
      await repo.rejectOffer(driverId, widget.offer.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.type;
    final offer = widget.offer;
    final toPickup = metersBetween(widget.driverPosition, offer.pickup.point) * 1.3;
    final toPickupSeconds = toPickup / (25 / 3.6);
    final curve = CurvedAnimation(parent: _enter, curve: TcMotion.enter);

    return Stack(
      children: [
        Positioned.fill(
          child: FadeTransition(
            opacity: curve,
            child: ColoredBox(color: c.scrim.withValues(alpha: 0.35)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(curve),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: TcRadius.sheet,
                boxShadow: TcElevation.high(c.shadow),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(TcSpace.gutter, TcSpace.x5, TcSpace.gutter, TcSpace.x4),
                  child: Semantics(
                    liveRegion: true,
                    label: 'Nueva solicitud de viaje',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TcStatusPill(
                                    label: 'Nueva solicitud',
                                    tone: TcStatusTone.brand,
                                    icon: Icons.notifications_active_rounded,
                                  ),
                                  const SizedBox(height: TcSpace.x2),
                                  TcPrice(Fmt.money(offer.quote.estimate), size: TcPriceSize.hero),
                                  Text(
                                    '${offer.payment.label} · ${offer.type.label}',
                                    style: t.body.copyWith(color: c.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            if (offer.offerExpiresAt != null)
                              TcCountdownRing(
                                deadline: offer.offerExpiresAt!,
                                total: SimulatedTripRepository.offerWindow,
                              ),
                          ],
                        ),
                        const SizedBox(height: TcSpace.x4),
                        TcRouteSummary(
                          pickupTitle: offer.pickup.name,
                          pickupSubtitle: 'A ${Fmt.distance(toPickup)} · ${Fmt.minutes(toPickupSeconds)} de ti',
                          destinationTitle: offer.destination.name,
                          destinationSubtitle:
                              'Viaje de ${Fmt.distance(offer.route.distanceMeters)} · ${Fmt.minutes(offer.route.durationSeconds)}',
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: TcSpace.x4), child: Divider()),
                        TcPersonRow(
                          name: offer.rider.name,
                          rating: offer.rider.rating,
                          trips: offer.rider.trips,
                        ),
                        const SizedBox(height: TcSpace.x5),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TcButton(
                                label: 'Rechazar',
                                variant: TcButtonVariant.outline,
                                onPressed: _busy ? null : () => _respond(accept: false),
                              ),
                            ),
                            const SizedBox(width: TcSpace.x3),
                            Expanded(
                              flex: 3,
                              child: TcButton(
                                label: 'Aceptar viaje',
                                icon: Icons.check_rounded,
                                loading: _busy,
                                onPressed: () => _respond(accept: true),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
