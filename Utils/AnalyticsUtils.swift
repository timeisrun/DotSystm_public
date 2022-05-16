//
//  AnalyticsUtils.swift
//  DotSystem
//
//  Created by ccc on 2022/1/23.
//

import FirebaseAnalytics

enum EventType {
    
    case home_game
    case home_game_confirm
    case home_game_cancel
    case home_leisure
    case home_leisure_conways
    case home_leisure_langtons
    case home_leisure_cancel
    case home_achievement
    case home_setting_music_close
    case home_setting_music_open
    case home_add_energy
    case home_energy_isnt_enough
    
    case ad_load_success
    case ad_load_failed
    case ad_watch_success
    case ad_cancel
    
    case game_tap_panel
    case game_pause
    case game_play
    case game_giveup
    case game_giveup_sure
    case game_giveup_cancel
    case game_question
    case game_camera
    case game_range
    case game_range_show
    case game_range_not_show
    
    case achievement_cancel
    
    case version_have_new
    case version_url_error
    case version_url_get_data_error
    case version_convert_json_error
    case version_results_field_error
    case version_results_array_count_error
    case version_version_field_error
    case version_release_notes_field_error
    case version_local_version_num_error
    
    case version_choose_update
    case version_choose_dont_update
    
    case leisure_conways_tap_panel
    case leisure_conways_pause
    case leisure_conways_play
    case leisure_conways_giveup
    case leisure_conways_giveup_sure
    case leisure_conways_giveup_cancel
    case leisure_conways_question
    case leisure_conways_camera
    case leisure_conways_winner
    
    case leisure_langtons_tap_panel
    case leisure_langtons_pause
    case leisure_langtons_play
    case leisure_langtons_giveup
    case leisure_langtons_giveup_sure
    case leisure_langtons_giveup_cancel
    case leisure_langtons_question
    case leisure_langtons_camera
}

class AnalyticsUtils {
    
    static func sendEvent(type: EventType, helpData: String = "") {
        let name = String(describing: type.self)
        Analytics.logEvent(name, parameters: [
            "helpData": helpData as NSObject
        ])
    }
    
}
