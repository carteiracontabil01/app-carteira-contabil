import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'avaliacoes_model.dart';
export 'avaliacoes_model.dart';

class AvaliacoesWidget extends StatefulWidget {
  const AvaliacoesWidget({
    super.key,
    required this.driverId,
    this.ratings,
  });

  final String driverId;
  final List<MotoboyRatingsRow>? ratings;

  static String routeName = 'avaliacoesDriver';
  static String routePath = 'avaliacoes-driver';

  @override
  State<AvaliacoesWidget> createState() => _AvaliacoesWidgetState();
}

class _AvaliacoesWidgetState extends State<AvaliacoesWidget> {
  late AvaliacoesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AvaliacoesModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 30.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Minhas Avaliações',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  font: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: FutureBuilder<List<MotoboyRatingsRow>>(
            future: widget.ratings != null
                ? Future.value(widget.ratings!)
                : MotoboyRatingsTable().queryRows(
                    queryFn: (q) => q
                        .eq('delivery_person_id', widget.driverId)
                        .order('created_at', ascending: false),
                  ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              }

              final ratings = snapshot.data!;

              if (ratings.isEmpty) {
                return _buildEmptyState(context);
              }

              // Calcular estatísticas
              final avgRating = ratings.fold<double>(
                    0,
                    (sum, rating) => sum + rating.rating,
                  ) /
                  ratings.length;

              final ratingDistribution = <int, int>{
                5: 0,
                4: 0,
                3: 0,
                2: 0,
                1: 0,
              };

              for (var rating in ratings) {
                ratingDistribution[rating.rating] =
                    (ratingDistribution[rating.rating] ?? 0) + 1;
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card de resumo
                    Container(
                      width: double.infinity,
                      padding: EdgeInsetsDirectional.all(24.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        border: Border(
                          bottom: BorderSide(
                            color: FlutterFlowTheme.of(context).grayscale20,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Média grande
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                avgRating.toStringAsFixed(1),
                                style: FlutterFlowTheme.of(context)
                                    .displayLarge
                                    .override(
                                      font: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.only(
                                  bottom: 8.0,
                                  start: 4.0,
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  color: FlutterFlowTheme.of(context).warning,
                                  size: 32.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '${ratings.length} ${ratings.length == 1 ? 'avaliação' : 'avaliações'}',
                            style:
                                FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.nunito(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                          SizedBox(height: 24.0),

                          // Distribuição de estrelas
                          ...List.generate(5, (index) {
                            final stars = 5 - index;
                            final count = ratingDistribution[stars] ?? 0;
                            final percentage = ratings.isNotEmpty
                                ? (count / ratings.length).toDouble()
                                : 0.0;

                            return Padding(
                              padding: EdgeInsetsDirectional.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Text(
                                    '$stars',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  SizedBox(width: 4.0),
                                  Icon(
                                    Icons.star_rounded,
                                    color: FlutterFlowTheme.of(context).warning,
                                    size: 16.0,
                                  ),
                                  SizedBox(width: 12.0),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: LinearProgressIndicator(
                                        value: percentage,
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .grayscale20,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          FlutterFlowTheme.of(context).warning,
                                        ),
                                        minHeight: 8.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.0),
                                  Text(
                                    '$count',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.nunito(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // Lista de avaliações
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Text(
                        'Todas as Avaliações',
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: ratings.length,
                      itemBuilder: (context, index) {
                        final rating = ratings[index];
                        return _buildRatingItem(context, rating);
                      },
                    ),

                    SizedBox(height: 24.0),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRatingItem(BuildContext context, MotoboyRatingsRow rating) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      padding: EdgeInsetsDirectional.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).grayscale20,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com estrelas e data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Estrelas
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: FlutterFlowTheme.of(context).warning,
                    size: 20.0,
                  );
                }),
              ),
              // Data
              Text(
                DateFormat('dd/MM/yyyy').format(rating.createdAt),
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.nunito(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),

          // Comentário (se existir)
          if (rating.comment != null && rating.comment!.isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.only(top: 12.0),
              child: Text(
                rating.comment!,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.nunito(),
                      letterSpacing: 0.0,
                    ),
              ),
            ),

          // Avaliado por
          Padding(
            padding: EdgeInsetsDirectional.only(top: 8.0),
            child: Row(
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 14.0,
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    rating.ratedBy == 'customer' ? 'Cliente' : 'Loja',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color:
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_outline_rounded,
                size: 50.0,
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Nenhuma avaliação ainda',
              style: FlutterFlowTheme.of(context).titleLarge.override(
                    font: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Suas avaliações aparecerão aqui após completar suas primeiras entregas.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.nunito(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

