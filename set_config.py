import json

def set_config(json_file_path, increment=None, mixer=None):
    config_file = open(json_file_path)
    config = json.load(config_file)
    config_file.close()

    config['mixer'] = mixer if mixer else config['mixer']
    config['increment'] = int(increment) if increment else config['increment']

    config_file = open(json_file_path, "w")
    
    config_file.write(json.dumps(config))

    config_file.close()