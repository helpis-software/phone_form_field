import 'package:phone_form_field/phone_form_field.dart';

/// this saves the localized countries for each country
/// for a given language in a cache, so it does not
/// have to be recreated

class LocalizedCountryRegistry {
  LocalizedCountryRegistry._(this._localization);

  factory LocalizedCountryRegistry.cached(
    final PhoneFieldLocalization localization,
  ) {
    final LocalizedCountryRegistry? instance = _instance;
    if (instance != null && instance._localization == localization) {
      return instance;
    }
    return LocalizedCountryRegistry._(localization);
  }
  final PhoneFieldLocalization _localization;

  static LocalizedCountryRegistry? _instance;

  late final Map<IsoCode, Country> _localizedCountries =
      Map<IsoCode, Country>.fromIterable(
    // remove iso codes that do not have a traduction yet..
    IsoCode.values.where(_names.containsKey),
    value: (final dynamic isoCode) => Country(isoCode, _names[isoCode]!),
  );

  Country? find(final IsoCode isoCode) => _localizedCountries[isoCode];

  /// gets localized countries from isocodes
  List<Country> whereIsoIn(
    final List<IsoCode> isoCodes, {
    final List<IsoCode> omit = const <IsoCode>[],
  }) {
    final Set<IsoCode> omitSet = Set<IsoCode>.from(omit);
    return isoCodes
        .where((final IsoCode isoCode) => !omitSet.contains(isoCode))
        .where(_localizedCountries.containsKey)
        .map((final IsoCode iso) => _localizedCountries[iso]!)
        .toList();
  }

  late final Map<IsoCode, String> _names = <IsoCode, String>{
    IsoCode.AC: _localization.ac_,
    IsoCode.AD: _localization.ad_,
    IsoCode.AE: _localization.ae_,
    IsoCode.AF: _localization.af_,
    IsoCode.AG: _localization.ag_,
    IsoCode.AI: _localization.ai_,
    IsoCode.AL: _localization.al_,
    IsoCode.AM: _localization.am_,
    IsoCode.AO: _localization.ao_,
    IsoCode.AR: _localization.ar_,
    IsoCode.AS: _localization.as_,
    IsoCode.AT: _localization.at_,
    IsoCode.AU: _localization.au_,
    IsoCode.AW: _localization.aw_,
    IsoCode.AX: _localization.ax_,
    IsoCode.AZ: _localization.az_,
    IsoCode.BA: _localization.ba_,
    IsoCode.BB: _localization.bb_,
    IsoCode.BD: _localization.bd_,
    IsoCode.BE: _localization.be_,
    IsoCode.BF: _localization.bf_,
    IsoCode.BG: _localization.bg_,
    IsoCode.BH: _localization.bh_,
    IsoCode.BI: _localization.bi_,
    IsoCode.BJ: _localization.bj_,
    IsoCode.BL: _localization.bl_,
    IsoCode.BM: _localization.bm_,
    IsoCode.BN: _localization.bn_,
    IsoCode.BO: _localization.bo_,
    IsoCode.BQ: _localization.bq_,
    IsoCode.BR: _localization.br_,
    IsoCode.BS: _localization.bs_,
    IsoCode.BT: _localization.bt_,
    IsoCode.BW: _localization.bw_,
    IsoCode.BY: _localization.by_,
    IsoCode.BZ: _localization.bz_,
    IsoCode.CA: _localization.ca_,
    IsoCode.CC: _localization.cc_,
    IsoCode.CD: _localization.cd_,
    IsoCode.CF: _localization.cf_,
    IsoCode.CG: _localization.cg_,
    IsoCode.CH: _localization.ch_,
    IsoCode.CI: _localization.ci_,
    IsoCode.CK: _localization.ck_,
    IsoCode.CL: _localization.cl_,
    IsoCode.CM: _localization.cm_,
    IsoCode.CN: _localization.cn_,
    IsoCode.CO: _localization.co_,
    IsoCode.CR: _localization.cr_,
    IsoCode.CU: _localization.cu_,
    IsoCode.CV: _localization.cv_,
    IsoCode.CX: _localization.cx_,
    IsoCode.CY: _localization.cy_,
    IsoCode.CZ: _localization.cz_,
    IsoCode.DE: _localization.de_,
    IsoCode.DJ: _localization.dj_,
    IsoCode.DK: _localization.dk_,
    IsoCode.DM: _localization.dm_,
    IsoCode.DO: _localization.do_,
    IsoCode.DZ: _localization.dz_,
    IsoCode.EC: _localization.ec_,
    IsoCode.EE: _localization.ee_,
    IsoCode.EG: _localization.eg_,
    IsoCode.ER: _localization.er_,
    IsoCode.ES: _localization.es_,
    IsoCode.ET: _localization.et_,
    IsoCode.FI: _localization.fi_,
    IsoCode.FJ: _localization.fj_,
    IsoCode.FK: _localization.fk_,
    IsoCode.FM: _localization.fm_,
    IsoCode.FO: _localization.fo_,
    IsoCode.FR: _localization.fr_,
    IsoCode.GA: _localization.ga_,
    IsoCode.GB: _localization.gb_,
    IsoCode.GD: _localization.gd_,
    IsoCode.GE: _localization.ge_,
    IsoCode.GF: _localization.gf_,
    IsoCode.GG: _localization.gg_,
    IsoCode.GH: _localization.gh_,
    IsoCode.GI: _localization.gi_,
    IsoCode.GL: _localization.gl_,
    IsoCode.GM: _localization.gm_,
    IsoCode.GN: _localization.gn_,
    IsoCode.GP: _localization.gp_,
    IsoCode.GQ: _localization.gq_,
    IsoCode.GR: _localization.gr_,
    IsoCode.GT: _localization.gt_,
    IsoCode.GU: _localization.gu_,
    IsoCode.GW: _localization.gw_,
    IsoCode.GY: _localization.gy_,
    IsoCode.HK: _localization.hk_,
    IsoCode.HN: _localization.hn_,
    IsoCode.HR: _localization.hr_,
    IsoCode.HT: _localization.ht_,
    IsoCode.HU: _localization.hu_,
    IsoCode.ID: _localization.id_,
    IsoCode.IE: _localization.ie_,
    IsoCode.IL: _localization.il_,
    IsoCode.IM: _localization.im_,
    IsoCode.IN: _localization.in_,
    IsoCode.IO: _localization.io_,
    IsoCode.IQ: _localization.iq_,
    IsoCode.IR: _localization.ir_,
    IsoCode.IS: _localization.is_,
    IsoCode.IT: _localization.it_,
    IsoCode.JE: _localization.je_,
    IsoCode.JM: _localization.jm_,
    IsoCode.JO: _localization.jo_,
    IsoCode.JP: _localization.jp_,
    IsoCode.KE: _localization.ke_,
    IsoCode.KG: _localization.kg_,
    IsoCode.KH: _localization.kh_,
    IsoCode.KI: _localization.ki_,
    IsoCode.KM: _localization.km_,
    IsoCode.KN: _localization.kn_,
    IsoCode.KP: _localization.kp_,
    IsoCode.KR: _localization.kr_,
    IsoCode.KW: _localization.kw_,
    IsoCode.KY: _localization.ky_,
    IsoCode.KZ: _localization.kz_,
    IsoCode.LA: _localization.la_,
    IsoCode.LB: _localization.lb_,
    IsoCode.LC: _localization.lc_,
    IsoCode.LI: _localization.li_,
    IsoCode.LK: _localization.lk_,
    IsoCode.LR: _localization.lr_,
    IsoCode.LS: _localization.ls_,
    IsoCode.LT: _localization.lt_,
    IsoCode.LU: _localization.lu_,
    IsoCode.LV: _localization.lv_,
    IsoCode.LY: _localization.ly_,
    IsoCode.MA: _localization.ma_,
    IsoCode.MC: _localization.mc_,
    IsoCode.MD: _localization.md_,
    IsoCode.ME: _localization.me_,
    IsoCode.MF: _localization.mf_,
    IsoCode.MG: _localization.mg_,
    IsoCode.MH: _localization.mh_,
    IsoCode.MK: _localization.mk_,
    IsoCode.ML: _localization.ml_,
    IsoCode.MM: _localization.mm_,
    IsoCode.MN: _localization.mn_,
    IsoCode.MO: _localization.mo_,
    IsoCode.MP: _localization.mp_,
    IsoCode.MQ: _localization.mq_,
    IsoCode.MR: _localization.mr_,
    IsoCode.MS: _localization.ms_,
    IsoCode.MT: _localization.mt_,
    IsoCode.MU: _localization.mu_,
    IsoCode.MV: _localization.mv_,
    IsoCode.MW: _localization.mw_,
    IsoCode.MX: _localization.mx_,
    IsoCode.MY: _localization.my_,
    IsoCode.MZ: _localization.mz_,
    IsoCode.NA: _localization.na_,
    IsoCode.NC: _localization.nc_,
    IsoCode.NE: _localization.ne_,
    IsoCode.NF: _localization.nf_,
    IsoCode.NG: _localization.ng_,
    IsoCode.NI: _localization.ni_,
    IsoCode.NL: _localization.nl_,
    IsoCode.NO: _localization.no_,
    IsoCode.NP: _localization.np_,
    IsoCode.NR: _localization.nr_,
    IsoCode.NU: _localization.nu_,
    IsoCode.NZ: _localization.nz_,
    IsoCode.OM: _localization.om_,
    IsoCode.PA: _localization.pa_,
    IsoCode.PE: _localization.pe_,
    IsoCode.PF: _localization.pf_,
    IsoCode.PG: _localization.pg_,
    IsoCode.PH: _localization.ph_,
    IsoCode.PK: _localization.pk_,
    IsoCode.PL: _localization.pl_,
    IsoCode.PM: _localization.pm_,
    IsoCode.PR: _localization.pr_,
    IsoCode.PS: _localization.ps_,
    IsoCode.PT: _localization.pt_,
    IsoCode.PW: _localization.pw_,
    IsoCode.PY: _localization.py_,
    IsoCode.QA: _localization.qa_,
    IsoCode.RE: _localization.re_,
    IsoCode.RO: _localization.ro_,
    IsoCode.RS: _localization.rs_,
    IsoCode.RU: _localization.ru_,
    IsoCode.RW: _localization.rw_,
    IsoCode.SA: _localization.sa_,
    IsoCode.SB: _localization.sb_,
    IsoCode.SC: _localization.sc_,
    IsoCode.SD: _localization.sd_,
    IsoCode.SE: _localization.se_,
    IsoCode.SG: _localization.sg_,
    IsoCode.SI: _localization.si_,
    IsoCode.SK: _localization.sk_,
    IsoCode.SL: _localization.sl_,
    IsoCode.SM: _localization.sm_,
    IsoCode.SN: _localization.sn_,
    IsoCode.SO: _localization.so_,
    IsoCode.SR: _localization.sr_,
    IsoCode.SS: _localization.ss_,
    IsoCode.ST: _localization.st_,
    IsoCode.SV: _localization.sv_,
    IsoCode.SY: _localization.sy_,
    IsoCode.SZ: _localization.sz_,
    IsoCode.TA: _localization.ta_,
    IsoCode.TC: _localization.tc_,
    IsoCode.TD: _localization.td_,
    IsoCode.TG: _localization.tg_,
    IsoCode.TH: _localization.th_,
    IsoCode.TJ: _localization.tj_,
    IsoCode.TK: _localization.tk_,
    IsoCode.TL: _localization.tl_,
    IsoCode.TM: _localization.tm_,
    IsoCode.TN: _localization.tn_,
    IsoCode.TO: _localization.to_,
    IsoCode.TR: _localization.tr_,
    IsoCode.TT: _localization.tt_,
    IsoCode.TV: _localization.tv_,
    IsoCode.TW: _localization.tw_,
    IsoCode.TZ: _localization.tz_,
    IsoCode.UA: _localization.ua_,
    IsoCode.UG: _localization.ug_,
    IsoCode.US: _localization.us_,
    IsoCode.UY: _localization.uy_,
    IsoCode.UZ: _localization.uz_,
    IsoCode.VA: _localization.va_,
    IsoCode.VC: _localization.vc_,
    IsoCode.VE: _localization.ve_,
    IsoCode.VG: _localization.vg_,
    IsoCode.VI: _localization.vi_,
    IsoCode.VN: _localization.vn_,
    IsoCode.VU: _localization.vu_,
    IsoCode.WF: _localization.wf_,
    IsoCode.WS: _localization.ws_,
    IsoCode.YE: _localization.ye_,
    IsoCode.YT: _localization.yt_,
    IsoCode.ZA: _localization.za_,
    IsoCode.ZM: _localization.zm_,
    IsoCode.ZW: _localization.zw_
  };
}
