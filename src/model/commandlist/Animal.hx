package model.commandlist;

import discordhx.message.Message;
import config.AuthDetails;
import utils.ArrayUtils;
import haxe.Json;
import utils.DiscordUtils;
import nodejs.http.HTTP.HTTPMethod;
import utils.Logger;
import utils.HttpUtils;
import translations.LangCenter;

class Animal implements ICommandDefinition {
    public var paramsUsage = '';
    public var description: String;
    public var hidden = false;

    private var _context: CommunicationContext;

    public function new(context: CommunicationContext) {
        var serverId = DiscordUtils.getServerIdFromMessage(context.getMessage());

        _context = context;
        description = LangCenter.instance.translate(serverId, 'model.commandlist.animal.description');
    }

    public function process(args: Array<String>): Void {
        var author = _context.getMessage().author;
        var bestArray: Array<String> = new Array<String>();
        var domain = 'api.gettyimages.com';
        var path = '/v3/search/images';
        var headers = new Map<String, String>();
        var search: String = StringTools.trim(args.join(' '));

        if (search == 'awoo') {
            search = 'wolf howl';
        }

        if (search == null || search.length < 1) {
            search = 'animal';
        }

        path += '?embed_content_only=true';
        path += '&exclude_nudity=true';
        path += '&fields=display_set';
        path += '&file_types=jpg';
        path += '&number_of_people=none';
        path += '&phrase=' + StringTools.urlEncode(search);
        path += '&sort_order=best_match';

        headers.set('Api-Key', AuthDetails.GETTY_KEY);

        HttpUtils.query(true, domain, path, cast HTTPMethod.Get, function (data: String) {
            var response: Dynamic = null;

            try {
                response = Json.parse(data);
            } catch (err: Dynamic) {
                Logger.exception(err);
            }

            if (response != null && Reflect.hasField(response, 'result_count') && Reflect.hasField(response, 'images')) {
                if (response.result_count > 0) {
                    var nbResults: Int = response.result_count;
                    var nbPerPage: Int = response.images.length;
                    var nbPages: Int = cast Math.min(Math.ceil(nbResults / nbPerPage), 6); // Limit at 6 pages so we don't end up with unrelevant content

                    HttpUtils.query(true, domain, path + '&page=' + Math.ceil(Math.random() * nbPages + 0.1), cast HTTPMethod.Get, function (data: String) {
                        var response: Dynamic = null;

                        try {
                            response = Json.parse(data);
                        } catch (err: Dynamic) {
                            Logger.exception(err);
                        }

                        if (response != null && Reflect.hasField(response, 'result_count') && Reflect.hasField(response, 'images')) {
                            var image: Dynamic = ArrayUtils.random(cast response.images);
                            var displaySizes: Array<Dynamic> = image.display_sizes;
                            var uri: String = displaySizes[0].uri;
                            var hash: Int = 0;

                            for (i in 0...uri.length) {
                                hash  = ((hash << 5) - hash) + uri.charCodeAt(i);
                                hash |= 0;
                            }

                            _context.sendFileToChannel(displaySizes[0].uri, hash + '.png', function (err: Dynamic, message: Message) {
                                if (err != null) {
                                    Logger.error('Failed to load Getty image (step 3)');
                                    Logger.debug(response);

                                    _context.sendToChannel('model.commandlist.animal.process.fail', cast [author]);
                                }
                            });
                        } else {
                            Logger.error('Failed to load Getty image (step 2)');
                            Logger.debug(response);

                            _context.sendToChannel('model.commandlist.animal.process.fail', cast [author]);
                        }
                    }, null, headers);
                } else {
                    _context.sendToChannel('model.commandlist.animal.process.not_found', cast [author]);
                }
            } else {
                Logger.error('Failed to load Getty image (step 1)');
                Logger.debug(response);

                _context.sendToChannel('model.commandlist.animal.process.fail', cast [author]);
            }
        }, null, headers);
    }
}
