import Foundation

extension String {
  var localized: String { return WFSLanguageManager.sharedInstance.valueWithKey(key: self) }
/* 
  Localizable.strings
  Canonchain

  Created by LEE on 7/30/18.
  Copyright © 2018 LEE. All rights reserved.
*/




//tabbar

  static var localized_marker : String{ return "marker".localized}
  static var localized_bibi_transaction : String{ return "bibi_transaction".localized}
  static var localized_fabi_transaction : String{ return "fabi_transaction".localized}
  static var localized_my : String{ return "my".localized}
  static var localized_user_btn_register : String{ return "user_btn_register".localized}
  static var localized_user_tv_email_register : String{ return "user_tv_email_register".localized}
  static var localized_user_phone_hint : String{ return "user_phone_hint".localized}
  static var localized_user_sms_code_hint : String{ return "user_sms_code_hint".localized}
  static var localized_user_email_code_hint : String{ return "user_email_code_hint".localized}
  static var localized_user_et_password_hint : String{ return "user_et_password_hint".localized}
  static var localized_user_et_re_password_hint : String{ return "user_et_re_password_hint".localized}
  static var localized_user_find_back_password : String{ return "user_find_back_password".localized}
  static var localized_user_tv_already_has_account : String{ return "user_tv_already_has_account".localized}
  static var localized_tv_user_register : String{ return "tv_user_register".localized}
  static var localized_et_account_email_hint : String{ return "et_account_email_hint".localized}
  static var localized_et_account_hint : String{ return "et_account_hint".localized}
  static var localized_btn_login : String{ return "btn_login".localized}
  static var localized_tv_forget_password : String{ return "tv_forget_password".localized}
  static var localized_title_bar_find_login_password : String{ return "title_bar_find_login_password".localized}
  static var localized_modify_login_password : String{ return "modify_login_password".localized}
  static var localized_et_search_key_hint : String{ return "et_search_key_hint".localized}
  static var localized_b2b_tv_time : String{ return "b2b_tv_time".localized}
  static var localized_buy : String{ return "buy".localized}
  static var localized_Buy : String{ return "Buy".localized}
  static var localized_buy_label : String{ return "buy_label".localized}
  static var localized_sale_label : String{ return "sale_label".localized}
  static var localized_sale : String{ return "sale".localized}
  static var localized_Sale : String{ return "Sale".localized}
  static var localized_market_price : String{ return "market_price".localized}
  static var localized_current_price : String{ return "current_price".localized}
  static var localized_current_best_prices : String{ return "current_best_prices".localized}
  static var localized_num : String{ return "num".localized}
  static var localized_sum : String{ return "sum".localized}
  static var localized_dish_port : String{ return "dish_port".localized}
  static var localized_price : String{ return "price".localized}
  static var localized_more : String{ return "more".localized}
  static var localized_current_entrust : String{ return "current_entrust".localized}
  static var localized_history_entrust : String{ return "history_entrust".localized}
  static var localized_all_record : String{ return "all_record".localized}
  static var localized_depth : String{ return "depth".localized}
  static var localized_depth_1 : String{ return "depth_1".localized}
  static var localized_depth_2 : String{ return "depth_2".localized}
  static var localized_depth_3 : String{ return "depth_3".localized}
  static var localized_depth_4 : String{ return "depth_4".localized}
  static var localized_cancel : String{ return "cancel".localized}
  static var localized_market : String{ return "market".localized}

  static var localized_search : String{ return "search".localized}
  static var localized_favorites : String{ return "favorites".localized}
  static var localized_hr_24_amount : String{ return "hr_24_amount".localized}

  static var localized_depth_style_1 : String{ return "depth_style_1".localized}
  static var localized_depth_style_2 : String{ return "depth_style_2".localized}
  static var localized_depth_style_3 : String{ return "depth_style_3".localized}

  static var localized_available : String{ return "available".localized}
  static var localized_freeze : String{ return "freeze".localized}

  static var localized_add_favorites : String{ return "add_favorites".localized}
  static var localized_added : String{ return "added".localized}

  static var localized_btc_type : String{ return "btc_type".localized}
  static var localized_limit : String{ return "limit".localized}
  static var localized_opt : String{ return "opt".localized}

  static var localized_purchase : String{ return "purchase".localized}
  static var localized_sell : String{ return "sell".localized}

  static var localized_limit_buy : String{ return "limit_buy".localized}
  static var localized_full_purchase : String{ return "full_purchase".localized}

  static var localized_limit_sell : String{ return "limit_sell".localized}
  static var localized_full_sale : String{ return "full_sale".localized}

  static var localized_index_price : String{ return "index_price".localized}
  static var localized_float_price : String{ return "float_price".localized}

  static var localized_fix_price : String{ return "fix_price".localized}
  static var localized_trade_limit : String{ return "trade_limit".localized}
  static var localized_fix_amount : String{ return "fix_amount".localized}

  static var localized_ali_pay : String{ return "ali_pay".localized}
  static var localized_wechat_pay : String{ return "wechat_pay".localized}
  static var localized_bank_pay : String{ return "bank_pay".localized}

  static var localized_replicated : String{ return "replicated".localized}
  static var localized_reject : String{ return "reject".localized}
  static var localized_filter : String{ return "filter".localized}
  static var localized_cancel_order : String{ return "cancel_order".localized}

  static var localized_publish_advertising_hint : String{ return "publish_advertising_hint".localized}
  static var localized_sell_tip : String{ return "sell_tip".localized}
  static var localized_buy_tip : String{ return "buy_tip".localized}
  static var localized_buy_now : String{ return "buy_now".localized}
  static var localized_sell_now : String{ return "sell_now".localized}
  static var localized_legal_currency : String{ return "legal_currency".localized}
  static var localized_digital_currency : String{ return "digital_currency".localized}
  static var localized_buy_order_time : String{ return "buy_order_time".localized}

//币币交易
  static var localized_b2b_top_gainers : String{ return "b2b_top_gainers".localized}
  static var localized_my_postion : String{ return "my_postion".localized}
  static var localized_b2b_all : String{ return "b2b_all".localized}

//--发布广告页面--
  static var localized_i_want : String{ return "i_want".localized}
  static var localized_select_btc : String{ return "select_btc".localized}
  static var localized_currency : String{ return "currency".localized}
  static var localized_num_setting : String{ return "num_setting".localized}
  static var localized_unit_price_setting : String{ return "unit_price_setting".localized}
  static var localized_current_market_lowest_price : String{ return "current_market_lowest_price".localized}
  static var localized_current_market_highest_price : String{ return "current_market_highest_price".localized}
  static var localized_automatic_premium_setting : String{ return "automatic_premium_setting".localized}
  static var localized_total_price : String{ return "total_price".localized}
  static var localized_price_setting : String{ return "price_setting".localized}
  static var localized_float_ratio : String{ return "float_ratio".localized}
  static var localized_default_float : String{ return "default_float".localized}
  static var localized_unit_price : String{ return "unit_price".localized}
  static var localized_at_a_premium : String{ return "at_a_premium".localized}
  static var localized_accept_maximum_the_price_of : String{ return "accept_maximum_the_price_of".localized}
  static var localized_accept_minimum_the_price_of : String{ return "accept_minimum_the_price_of".localized}
  static var localized_transaction_setting : String{ return "transaction_setting".localized}
  static var localized_minimum_limit : String{ return "minimum_limit".localized}
  static var localized_biggest_limit : String{ return "biggest_limit".localized}
  static var localized_payment_way : String{ return "payment_way".localized}
  static var localized_collection_way : String{ return "collection_way".localized}
  static var localized_transaction_about : String{ return "transaction_about".localized}
  static var localized_publish_ad : String{ return "publish_ad".localized}
  static var localized_save_and_putaway : String{ return "save_and_putaway".localized}
  static var localized_to : String{ return "to".localized}
  static var localized_single_minimum : String{ return "single_minimum".localized}
  static var localized_single_maximum : String{ return "single_maximum".localized}
  static var localized_pub_ad_buy : String{ return "pub_ad_buy".localized}
  static var localized_pub_ad_sell : String{ return "pub_ad_sell".localized}

//-- 用户信息页--
  static var localized_real_name_authentication : String{ return "real_name_authentication".localized}
  static var localized_email_authentication : String{ return "email_authentication".localized}
  static var localized_mobile_authentication : String{ return "mobile_authentication".localized}
  static var localized_transaction_count : String{ return "transaction_count".localized}
  static var localized_degree_of_praise : String{ return "degree_of_praise".localized}
  static var localized_complaint_quantity : String{ return "complaint_quantity".localized}
  static var localized_win_a_lawsuit_quantity : String{ return "win_a_lawsuit_quantity".localized}

//-- 购买订单--
  static var localized_order_no : String{ return "order_no".localized}
  static var localized_transaction_money : String{ return "transaction_money".localized}
  static var localized_transaction_num : String{ return "transaction_num".localized}
  static var localized_transaction_price : String{ return "transaction_price".localized}
  static var localized_seller : String{ return "seller".localized}
  static var localized_collection_reference_no : String{ return "collection_reference_no".localized}
  static var localized_transaction_way : String{ return "transaction_way".localized}

  static var localized_optional : String{ return "optional".localized}
  static var localized_must : String{ return "must".localized}

//-- 我的 --
  static var localized_my_assets : String{ return "my_assets".localized}
  static var localized_collection_setting : String{ return "collection_setting".localized}
  static var localized_account_security : String{ return "account_security".localized}
  static var localized_identity_authentication : String{ return "identity_authentication".localized}
  static var localized_help : String{ return "help".localized}
  static var localized_help_center : String{ return "help_center".localized}
  static var localized_about_us : String{ return "about_us".localized}
  static var localized_language : String{ return "language".localized}
  static var localized_log_out : String{ return "log_out".localized}
  static var localized_log_out_current_account : String{ return "log_out_current_account".localized}
  static var localized_not_login : String{ return "not_login".localized}
  static var localized_touch_login_register : String{ return "touch_login_register".localized}
  static var localized_tip : String{ return "tip".localized}
  static var localized_login_out_tip : String{ return "login_out_tip".localized}
  static var localized_mine_language : String{ return "mine_language".localized}
  static var localized_set_nickname : String{ return "set_nickname".localized}
//-- 我的资产 --
  static var localized_total_assets : String{ return "total_assets".localized}
  static var localized_assets_convert_into : String{ return "assets_convert_into".localized}
  static var localized_search_assets : String{ return "search_assets".localized}
  static var localized_hide_the_zero_currency : String{ return "hide_the_zero_currency".localized}
  static var localized_point_QR_code : String{ return "point_QR_code".localized}

//-- 资产管理 --
  static var localized_mine_assets_management : String{ return "mine_assets_management".localized}
  static var localized_current : String{ return "current".localized}
  static var localized_recharge_coin : String{ return "recharge_coin".localized}
  static var localized_take_out_coin : String{ return "take_out_coin".localized}
  static var localized_time : String{ return "time".localized}
  static var localized_status : String{ return "status".localized}
  static var localized_take_out_coining : String{ return "take_out_coining".localized}
  static var localized_recharge_coining : String{ return "recharge_coining".localized}
  static var localized_take_out_coin_record : String{ return "take_out_coin_record".localized}
  static var localized_recharge_coin_record : String{ return "recharge_coin_record".localized}
  static var localized_transfer_history : String{ return "transfer_history".localized}
  static var localized_take_out_coin_success : String{ return "take_out_coin_success".localized}
  static var localized_recharge_coin_success : String{ return "recharge_coin_success".localized}
  static var localized_take_out_coin_failure : String{ return "take_out_coin_failure".localized}
  static var localized_recharge_coin_failure : String{ return "recharge_coin_failure".localized}
  static var localized_most_convertible : String{ return "most_convertible".localized}
//我的钱包
  static var localized_mine_assets_myPurse : String{ return "mine_assets_myPurse".localized}
  static var localized_mine_assets_bibiAssets : String{ return "mine_assets_bibiAssets".localized}
  static var localized_mine_assets_fabiAssets : String{ return "mine_assets_fabiAssets".localized}
  static var localized_mine_assets_deposit_record : String{ return "mine_assets_deposit_record".localized}
  static var localized_mine_assets_withdrawal_record : String{ return "mine_assets_withdrawal_record".localized}
  static var localized_mine_assets_transfer_record : String{ return "mine_assets_transfer_record".localized}
  static var localized_mine_assets_record : String{ return "mine_assets_record".localized}
//-- 提币 --
  static var localized_save_the_qr_code_image : String{ return "save_the_qr_code_image".localized}
  static var localized_copy_the_address : String{ return "copy_the_address".localized}
  static var localized_take_out_coin_des : String{ return "take_out_coin_des".localized}

//-- 提币 --
  static var localized_today_available : String{ return "today_available".localized}
  static var localized_take_out_coin_address : String{ return "take_out_coin_address".localized}
  static var localized_please_enter_the_take_out_coin_address : String{ return "please_enter_the_take_out_coin_address".localized}
  static var localized_take_out_coin_num : String{ return "take_out_coin_num".localized}
  static var localized_minimum_take_out_coin_num : String{ return "minimum_take_out_coin_num".localized}
  static var localized_service_charge : String{ return "service_charge".localized}
  static var localized_all_take_out : String{ return "all_take_out".localized}
  static var localized_the_actual_to_account : String{ return "the_actual_to_account".localized}
  static var localized_RichScan : String{ return "RichScan".localized}

//-- 账户安全 --
  static var localized_mailbox_authentication : String{ return "mailbox_authentication".localized}
  static var localized_phone_authentication : String{ return "phone_authentication".localized}
  static var localized_money_password : String{ return "money_password".localized}
  static var localized_reset_money_password : String{ return "reset_money_password".localized}
  static var localized_setup_money_password : String{ return "setup_money_password".localized}
  static var localized_google_authentication : String{ return "google_authentication".localized}
  static var localized_reset_google_authentication : String{ return "reset_google_authentication".localized}
  static var localized_login_password : String{ return "login_password".localized}
  static var localized_unbound : String{ return "unbound".localized}
  static var localized_modification : String{ return "modification".localized}
  static var localized_to_set_up : String{ return "to_set_up".localized}
  static var localized_not_set : String{ return "not_set".localized}
  static var localized_not_open : String{ return "not_open".localized}


//-- 委托详情 --
  static var localized_b2b_delegate_volume : String{ return "b2b_delegate_volume".localized}
  static var localized_b2b_trade_volume : String{ return "b2b_trade_volume".localized}
  static var localized_b2b_delegate_price : String{ return "b2b_delegate_price".localized}
  static var localized_b2b_delegate_trade_amount : String{ return "b2b_delegate_trade_amount".localized}
  static var localized_b2b_delegate_trade_average_price : String{ return "b2b_delegate_trade_average_price".localized}
  static var localized_b2b_delegate_trade_complete_price : String{ return "b2b_delegate_trade_complete_price".localized}
  static var localized_b2b_delegate_tran_amount : String{ return "b2b_delegate_tran_amount".localized}
  static var localized_b2b_fee : String{ return "b2b_fee".localized}
  static var localized_b2b_trade_status_part : String{ return "b2b_trade_status_part".localized}
  static var localized_b2b_trade_status_complete : String{ return "b2b_trade_status_complete".localized}
  static var localized_b2b_trade_status_cancel : String{ return "b2b_trade_status_cancel".localized}
  static var localized_b2b_trade_cancel_order : String{ return "b2b_trade_cancel_order".localized}
  static var localized_b2b_delegate_details : String{ return "b2b_delegate_details".localized}
  static var localized_b2b_delegate_appeal_success : String{ return "b2b_delegate_appeal_success".localized}
  static var localized_b2b_delegate_appeal_failure : String{ return "b2b_delegate_appeal_failure".localized}
//-- k线页面 --
//    case Line = "Line", fifteenM = "15min", oneH = "1hour", fourH = "4hour",oneD = "1day",oneM = "1min", fiveM = "5min", thirtyM = "30min",twoH = "2hour",sixH = "6hour",twelveH = "12hour", oneW = "1week"

  static var localized_b2b_high : String{ return "b2b_high".localized}
  static var localized_b2b_low : String{ return "b2b_low".localized}
  static var localized_b2b_24h_volume : String{ return "b2b_24h_volume".localized}
  static var localized_b2b_time_division : String{ return "b2b_time_division".localized}
  static var localized_b2b_time_15m : String{ return "b2b_time_15m".localized}
  static var localized_b2b_time_1h : String{ return "b2b_time_1h".localized}
  static var localized_b2b_time_4h : String{ return "b2b_time_4h".localized}
  static var localized_b2b_time_1d : String{ return "b2b_time_1d".localized}
  static var localized_b2b_more : String{ return "b2b_more".localized}
  static var localized_b2b_time_1m : String{ return "b2b_time_1m".localized}
  static var localized_b2b_time_5m : String{ return "b2b_time_5m".localized}
  static var localized_b2b_time_30m : String{ return "b2b_time_30m".localized}
  static var localized_b2b_time_2h : String{ return "b2b_time_2h".localized}
  static var localized_b2b_time_6h : String{ return "b2b_time_6h".localized}
  static var localized_b2b_time_12h : String{ return "b2b_time_12h".localized}
  static var localized_b2b_time_1w : String{ return "b2b_time_1w".localized}
  static var localized_b2b_index : String{ return "b2b_index".localized}
  static var localized_b2b_date : String{ return "b2b_date".localized}
  static var localized_b2b_open : String{ return "b2b_open".localized}
  static var localized_b2b_close : String{ return "b2b_close".localized}
  static var localized_b2b_rise_and_fall : String{ return "b2b_rise_and_fall".localized}
  static var localized_b2b_rise_and_fall_percent : String{ return "b2b_rise_and_fall_percent".localized}
  static var localized_b2b_executed : String{ return "b2b_executed".localized}
  static var localized_b2b_kline_price : String{ return "b2b_kline_price".localized}
  static var localized_b2b_trade_volume_label : String{ return "b2b_trade_volume_label".localized}
  static var localized_b2b_index_main : String{ return "b2b_index_main".localized}
  static var localized_b2b_index_sub : String{ return "b2b_index_sub".localized}
  static var localized_hide : String{ return "hide".localized}

//-- 最新成交 --
  static var localized_newest_make : String{ return "newest_make".localized}
  static var localized_b2b_price : String{ return "b2b_price".localized}
  static var localized_b2b_volume : String{ return "b2b_volume".localized}
  static var localized_b2b_direction : String{ return "b2b_direction".localized}

//-- 法币交易 --
  static var localized_legal_tender_asset : String{ return "legal_tender_asset".localized}
  static var localized_legal_please_enter_price : String{ return "legal_please_enter_price".localized}
  static var localized_legal_safety_verification : String{ return "legal_safety_verification".localized}
  static var localized_c2c_fixed_price : String{ return "c2c_fixed_price".localized}
  static var localized_c2c_order_history : String{ return "c2c_order_history".localized}
  static var localized_c2c_order_receiving : String{ return "c2c_order_receiving".localized}
  static var localized_c2c_float_price : String{ return "c2c_float_price".localized}
  static var localized_c2c_fixed_volume : String{ return "c2c_fixed_volume".localized}
  static var localized_c2c_trade_limit : String{ return "c2c_trade_limit".localized}
  static var localized_c2c_input_volume_tip : String{ return "c2c_input_volume_tip".localized}
  static var localized_c2c_input_buy_amount_tip : String{ return "c2c_input_buy_amount_tip".localized}
  static var localized_c2c_trade_way : String{ return "c2c_trade_way".localized}
  static var localized_c2c_trade_tip : String{ return "c2c_trade_tip".localized}
  static var localized_c2c_enter_password : String{ return "c2c_enter_password".localized}
  static var localized_c2c_system_message : String{ return "c2c_system_message".localized}
  static var localized_c2c_set_receipt_method : String{ return "c2c_set_receipt_method".localized}
  static var localized_c2c_limited_creating_orders : String{ return "c2c_limited_creating_orders".localized}
  static var localized_c2c_buy_order : String{ return "c2c_buy_order".localized}
  static var localized_c2c_sale_order : String{ return "c2c_sale_order".localized}
  static var localized_c2c_buyer : String{ return "c2c_buyer".localized}
  static var localized_c2c_seller : String{ return "c2c_seller".localized}
  static var localized_c2c_trade_complete_Date : String{ return "c2c_trade_complete_Date".localized}
  static var localized_c2c_order_number : String{ return "c2c_order_number".localized}
  static var localized_c2c_advert_remark : String{ return "c2c_advert_remark".localized}
  static var localized_c2c_trade_status_wait_pay : String{ return "c2c_trade_status_wait_pay".localized}
  static var localized_c2c_trade_status_wait_release : String{ return "c2c_trade_status_wait_release".localized}
  static var localized_c2c_trade_status_complaint : String{ return "c2c_trade_status_complaint".localized}
  static var localized_c2c_trade_status_complaint_tip : String{ return "c2c_trade_status_complaint_tip".localized}
  static var localized_c2c_trade_status_complete : String{ return "c2c_trade_status_complete".localized}
  static var localized_c2c_trade_status_cancel : String{ return "c2c_trade_status_cancel".localized}
  static var localized_c2c_trade_status_cancel_time : String{ return "c2c_trade_status_cancel_time".localized}
  static var localized_c2c_trade_status_trading : String{ return "c2c_trade_status_trading".localized}
  static var localized_c2c_trade_status_appealing : String{ return "c2c_trade_status_appealing".localized}
  static var localized_c2c_trade_completed : String{ return "c2c_trade_completed".localized}
  static var localized_c2c_trade_complete_time : String{ return "c2c_trade_complete_time".localized}
  static var localized_c2c_trade_already_cancel : String{ return "c2c_trade_already_cancel".localized}
  static var localized_c2c_trade_cancel_order : String{ return "c2c_trade_cancel_order".localized}
  static var localized_c2c_trade_appeal : String{ return "c2c_trade_appeal".localized}
  static var localized_c2c_trade_appeal_type : String{ return "c2c_trade_appeal_type".localized}
  static var localized_c2c_trade_appeal_time : String{ return "c2c_trade_appeal_time".localized}
  static var localized_c2c_trade_buyer_already_pay : String{ return "c2c_trade_buyer_already_pay".localized}
  static var localized_c2c_trade_wait_buyer_pay : String{ return "c2c_trade_wait_buyer_pay".localized}
  static var localized_c2c_trade_have_paid : String{ return "c2c_trade_have_paid".localized}
  static var localized_c2c_trade_confirm_release : String{ return "c2c_trade_confirm_release".localized}
  static var localized_c2c_chat_send : String{ return "c2c_chat_send".localized}
  static var localized_c2c_chat_et_hint : String{ return "c2c_chat_et_hint".localized}
  static var localized_c2c_volume_label : String{ return "c2c_volume_label".localized}
  static var localized_c2c_limit_label : String{ return "c2c_limit_label".localized}
  static var localized_c2c_asset_transfer : String{ return "c2c_asset_transfer".localized}
  static var localized_c2c_certain_transfer : String{ return "c2c_certain_transfer".localized}
  static var localized_c2c_transfer_amount : String{ return "c2c_transfer_amount".localized}
  static var localized_update_to_latest_version : String{ return "update_to_latest_version".localized}
  static var localized_wait_for_payment : String{ return "wait_for_payment".localized}
//-----获取聊天信息------market/gettalkmessagelist接口的返回值-----

  static var localized_gettalkmessagelist_1001 : String{ return "gettalkmessagelist_1001".localized}
  static var localized_gettalkmessagelist_1002 : String{ return "gettalkmessagelist_1002".localized}
  static var localized_gettalkmessagelist_1003 : String{ return "gettalkmessagelist_1003".localized}
  static var localized_gettalkmessagelist_1004 : String{ return "gettalkmessagelist_1004".localized}
//-- 用户相关 --
  static var localized_user_phone_verify_tip : String{ return "user_phone_verify_tip".localized}
  static var localized_user_bindings : String{ return "user_bindings".localized}
  static var localized_user_un_binging : String{ return "user_un_binging".localized}
  static var localized_user_modify : String{ return "user_modify".localized}
  static var localized_user_bind : String{ return "user_bind".localized}
  static var localized_user_go_setting : String{ return "user_go_setting".localized}
  static var localized_user_not_set : String{ return "user_not_set".localized}
  static var localized_user_reset : String{ return "user_reset".localized}
  static var localized_user_untie : String{ return "user_untie".localized}
  static var localized_user_change_mobile : String{ return "user_change_mobile".localized}
  static var localized_user_bind_mobile : String{ return "user_bind_mobile".localized}
  static var localized_user_have_opened : String{ return "user_have_opened".localized}
  static var localized_user_not_opened : String{ return "user_not_opened".localized}

  static var localized_send_authentication_code : String{ return "send_authentication_code".localized}
  static var localized_user_input_old_pwd_tip : String{ return "user_input_old_pwd_tip".localized}
  static var localized_user_input_new_pwd_tip : String{ return "user_input_new_pwd_tip".localized}
  static var localized_user_new_pwd : String{ return "user_new_pwd".localized}
  static var localized_user_confirm_new_pwd : String{ return "user_confirm_new_pwd".localized}
  static var localized_user_re_input_new_pwd_tip : String{ return "user_re_input_new_pwd_tip".localized}
  static var localized_user_input_pwd_not_same_tip : String{ return "user_input_pwd_not_same_tip".localized}
  static var localized_user_input_check_code_tip : String{ return "user_input_check_code_tip".localized}
  static var localized_user_input_phone_or_email_tip : String{ return "user_input_phone_or_email_tip".localized}
  static var localized_user_input_phone_or_email_hint : String{ return "user_input_phone_or_email_hint".localized}
  static var localized_user_send_email_code : String{ return "user_send_email_code".localized}
  static var localized_user_send_phone_code : String{ return "user_send_phone_code".localized}
  static var localized_user_input_google_code : String{ return "user_input_google_code".localized}
  static var localized_user_google_auth_tip : String{ return "user_google_auth_tip".localized}
  static var localized_user_copy_key : String{ return "user_copy_key".localized}
  static var localized_user_secret_key : String{ return "user_secret_key".localized}
  static var localized_user_google_auth_input_code : String{ return "user_google_auth_input_code".localized}
  static var localized_user_relieve_google_auth : String{ return "user_relieve_google_auth".localized}
  static var localized_user_confirm_bind : String{ return "user_confirm_bind".localized}
  static var localized_user_confirm_modify : String{ return "user_confirm_modify".localized}
  static var localized_user_login_register : String{ return "user_login_register".localized}
  static var localized_user_login_success : String{ return "user_login_success".localized}
  static var localized_user_input_account_tip : String{ return "user_input_account_tip".localized}
  static var localized_user_input_pwd_tip : String{ return "user_input_pwd_tip".localized}
  static var localized_user_input_email_tip : String{ return "user_input_email_tip".localized}
  static var localized_user_input_email_hint : String{ return "user_input_email_hint".localized}
  static var localized_user_input_correct_email_tip : String{ return "user_input_correct_email_tip".localized}
  static var localized_user_input_email_code_tip : String{ return "user_input_email_code_tip".localized}
  static var localized_user_input_email_code_hint : String{ return "user_input_email_code_hint".localized}
  static var localized_user_input_phone_code_tip : String{ return "user_input_phone_code_tip".localized}
  static var localized_user_input_phone_code_hint : String{ return "user_input_phone_code_hint".localized}
  static var localized_user_input_original_pwd : String{ return "user_input_original_pwd".localized}
  static var localized_user_input_nick_name_tip : String{ return "user_input_nick_name_tip".localized}
  static var localized_user_input_nick_name_not_empty : String{ return "user_input_nick_name_not_empty".localized}
  static var localized_user_input_old_phone_code_tip : String{ return "user_input_old_phone_code_tip".localized}
  static var localized_user_input_new_phone_code_tip : String{ return "user_input_new_phone_code_tip".localized}
  static var localized_user_input_correct_phone : String{ return "user_input_correct_phone".localized}
  static var localized_choose_country : String{ return "choose_country".localized}
  static var localized_country_code : String{ return "country_code".localized}
  static var localized_user_new_phone : String{ return "user_new_phone".localized}
  static var localized_user_register_success : String{ return "user_register_success".localized}
  static var localized_user_register_agreement : String{ return "user_register_agreement".localized}
  static var localized_user_register_to_login : String{ return "user_register_to_login".localized}
  static var localized_login_please_enter_psw : String{ return "login_please_enter_psw".localized}
  static var localized_user_input_withdraw_amount_tip : String{ return "user_input_withdraw_amount_tip".localized}
  static var localized_user_input_withdraw_balance_not_enough : String{ return "user_input_withdraw_balance_not_enough".localized}
  static var localized_user_input_admin_pwd : String{ return "user_input_admin_pwd".localized}
  static var localized_user_input_sms_code_tip : String{ return "user_input_sms_code_tip".localized}
  static var localized_user_open_google_auth : String{ return "user_open_google_auth".localized}
  static var localized_user_close_google_auth : String{ return "user_close_google_auth".localized}
  static var localized_user_google_code : String{ return "user_google_code".localized}
  static var localized_user_new_google_code : String{ return "user_new_google_code".localized}
  static var localized_user_relieve_google_code : String{ return "user_relieve_google_code".localized}
  static var localized_user_validate_email : String{ return "user_validate_email".localized}

  static var localized_save_pic : String{ return "save_pic".localized}
  static var localized_save_pic_success : String{ return "save_pic_success".localized}
  static var localized_save_pic_fail : String{ return "save_pic_fail".localized}
  static var localized_sure : String{ return "sure".localized}
  static var localized_next : String{ return "next".localized}
  static var localized_setting : String{ return "setting".localized}
  static var localized_china : String{ return "china".localized}

  static var localized_buy_advert : String{ return "buy_advert".localized}
  static var localized_sell_advert : String{ return "sell_advert".localized}

  static var localized_user_advert_status_on_shelf : String{ return "user_advert_status_on_shelf".localized}
  static var localized_user_advert_status_on_down : String{ return "user_advert_status_on_down".localized}
  static var localized_user_advert_price : String{ return "user_advert_price".localized}
  static var localized_user_advert_volume : String{ return "user_advert_volume".localized}
  static var localized_user_last_publish_time : String{ return "user_last_publish_time".localized}
  static var localized_trade : String{ return "trade".localized}


  static var localized_message : String{ return "message".localized}
  static var localized_notification_message : String{ return "notification_message".localized}
  static var localized_message_details : String{ return "message_details".localized}
  static var localized_account : String{ return "account".localized}
  static var localized_name : String{ return "name".localized}
  static var localized_bank : String{ return "bank".localized}
  static var localized_opening_bank : String{ return "opening_bank".localized}
  static var localized_transaction_pair : String{ return "transaction_pair".localized}
  static var localized_currency_label : String{ return "currency_label".localized}
  static var localized_select_unit : String{ return "select_unit".localized}
  static var localized_order_status : String{ return "order_status".localized}
  static var localized_advert_status : String{ return "advert_status".localized}
  static var localized_currency_choose : String{ return "currency_choose".localized}
  static var localized_tt_account : String{ return "tt_account".localized}
  static var localized_tt_name : String{ return "tt_name".localized}
  static var localized_tt_bank : String{ return "tt_bank".localized}
  static var localized_tt_card_number : String{ return "tt_card_number".localized}


//-- 法币最新列表 --
  static var localized_latest_purchase_price : String{ return "latest_purchase_price".localized}
  static var localized_latest_sale_price : String{ return "latest_sale_price".localized}

  static var localized_close_rate : String{ return "close_rate".localized}
//-- 收款设置 --
  static var localized_collection_go_setting : String{ return "collection_go_setting".localized}
  static var localized_collection_has_been_open : String{ return "collection_has_been_open".localized}
  static var localized_collection_closed : String{ return "collection_closed".localized}

//-- 银行卡设置--
  static var localized_open_bank_card_for_collection : String{ return "open_bank_card_for_collection".localized}
  static var localized_bank_card_for_collection_name : String{ return "bank_card_for_collection_name".localized}
  static var localized_choose_bank : String{ return "choose_bank".localized}
  static var localized_opening_bank_name : String{ return "opening_bank_name".localized}
  static var localized_bank_card_number : String{ return "bank_card_number".localized}

//-- 支付宝设置--
  static var localized_open_alipay_for_collection : String{ return "open_alipay_for_collection".localized}
  static var localized_alipay_account : String{ return "alipay_account".localized}
  static var localized_alipay_collection_people_name : String{ return "alipay_collection_people_name".localized}
  static var localized_receipt_code : String{ return "receipt_code".localized}
  static var localized_paid : String{ return "paid".localized}

//-- 微信设置--
  static var localized_open_wechat_for_collection : String{ return "open_wechat_for_collection".localized}
  static var localized_wechat_account : String{ return "wechat_account".localized}
  static var localized_wechat_collection_people_name : String{ return "wechat_collection_people_name".localized}

  static var localized_my_ad : String{ return "my_ad".localized}
  static var localized_order_management : String{ return "order_management".localized}
  static var localized_order_detail : String{ return "order_detail".localized}

//-- 身份认证 --
  static var localized_day_limit : String{ return "day_limit".localized}
  static var localized_please_contact : String{ return "please_contact".localized}
  static var localized_auth_status_un_submitted : String{ return "auth_status_un_submitted".localized}
  static var localized_auth_status_pending : String{ return "auth_status_pending".localized}
  static var localized_auth_status_passed : String{ return "auth_status_passed".localized}
  static var localized_auth_status_fail : String{ return "auth_status_fail".localized}
  static var localized_one_level_auth : String{ return "one_level_auth".localized}
  static var localized_second_level_auth : String{ return "second_level_auth".localized}
  static var localized_three_level_auth : String{ return "three_level_auth".localized}
  static var localized_have_reached_the_highest_level : String{ return "have_reached_the_highest_level".localized}
  static var localized_second_level_auth_success_tip : String{ return "second_level_auth_success_tip".localized}
  static var localized_three_level_auth_success_tip : String{ return "three_level_auth_success_tip".localized}
  static var localized_auth_success_contact : String{ return "auth_success_contact".localized}
  static var localized_id_card_font_pic : String{ return "id_card_font_pic".localized}
  static var localized_id_card_back_pic : String{ return "id_card_back_pic".localized}
  static var localized_id_card_hold_pic : String{ return "id_card_hold_pic".localized}
  static var localized_enter_id_card_number : String{ return "enter_id_card_number".localized}
  static var localized_id_card_font_pic_f : String{ return "id_card_font_pic_f".localized}
  static var localized_id_card_back_pic_f : String{ return "id_card_back_pic_f".localized}
  static var localized_id_card_hold_pic_f : String{ return "id_card_hold_pic_f".localized}
  static var localized_upload_fail : String{ return "upload_fail".localized}
  static var localized_uploading : String{ return "uploading".localized}
  static var localized_get_picture : String{ return "get_picture".localized}
  static var localized_photograph : String{ return "photograph".localized}
  static var localized_album : String{ return "album".localized}

  static var localized_second_level_auth_step_one_tip : String{ return "second_level_auth_step_one_tip".localized}
  static var localized_second_level_auth_step_two_tip : String{ return "second_level_auth_step_two_tip".localized}
  static var localized_submit : String{ return "submit".localized}
//帮助中心
  static var localized_question : String{ return "question".localized}
  static var localized_pack_up : String{ return "pack_up".localized}
  static var localized_view_more : String{ return "view_more".localized}
  static var localized_help_detail : String{ return "help_detail".localized}
  static var localized_placeholder_text : String{ return "placeholder_text".localized}



//收款设置
  static var localized_bank_BABC : String{ return "bank_BABC".localized}
  static var localized_bank_BOC : String{ return "bank_BOC".localized}
  static var localized_bank_ICBC : String{ return "bank_ICBC".localized}
  static var localized_bank_CMB : String{ return "bank_CMB".localized}
  static var localized_bank_CCB : String{ return "bank_CCB".localized}
  static var localized_bank_ABC : String{ return "bank_ABC".localized}
  static var localized_bank_GDB : String{ return "bank_GDB".localized}
  static var localized_bank_BCM : String{ return "bank_BCM".localized}
  static var localized_bank_CCBC : String{ return "bank_CCBC".localized}
  static var localized_bank_CEB : String{ return "bank_CEB".localized}
  static var localized_bank_CMBC : String{ return "bank_CMBC".localized}
  static var localized_bank_HXB : String{ return "bank_HXB".localized}
  static var localized_bank_SPDB : String{ return "bank_SPDB".localized}
  static var localized_bank_PSBC : String{ return "bank_PSBC".localized}
  static var localized_bank_CBHB : String{ return "bank_CBHB".localized}



  static var localized_confirm : String{ return "confirm".localized}
  static var localized_certain : String{ return "certain".localized}
  static var localized_retransmission_activation_mail : String{ return "retransmission_activation_mail".localized}
  static var localized_activation_mail_tip : String{ return "activation_mail_tip".localized}
  static var localized_activation_mail_tip1 : String{ return "activation_mail_tip1".localized}
  static var localized_activation_mail_tip2 : String{ return "activation_mail_tip2".localized}

  static var localized_cancel_order_tip : String{ return "cancel_order_tip".localized}

  static var localized_transfer : String{ return "transfer".localized}
  static var localized_recharge : String{ return "recharge".localized}
  static var localized_legal_tender_account : String{ return "legal_tender_account".localized}
  static var localized_virtual_tender_account : String{ return "virtual_tender_account".localized}
  static var localized_single_minute : String{ return "single_minute".localized}
  static var localized_single_second : String{ return "single_second".localized}
  static var localized_copy_success : String{ return "copy_success".localized}
  static var localized_load_fail : String{ return "load_fail".localized}
  static var localized_loading : String{ return "loading".localized}
//MJRefresh刷新
  static var localized_MJRefresh_pull : String{ return "MJRefresh_pull".localized}
  static var localized_MJRefresh_willFreshing : String{ return "MJRefresh_willFreshing".localized}
  static var localized_MJRefresh_freshing : String{ return "MJRefresh_freshing".localized}


}
