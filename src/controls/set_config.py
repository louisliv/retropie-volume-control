import json

def set_config(json_file_path, increment=None, mixer=None):
    config_file = open(json_file_path)
    config = json.load(config_file)
    config_file.close()

    if mixer:
        set_mixer(json_file_path, config, mixer.replace("_", " "))
    elif increment:
        set_increment(json_file_path, config, int(increment))

def set_mixer(json_file_path, config, mixer):
    config['mixer'] = mixer
    config_file = open(json_file_path, "w")
    
    config_file.write(json.dumps(config))

    config_file.close()

def set_increment(json_file_path, config, increment):
    config['increment'] = increment
    config_file = open(json_file_path, "w")
    
    config_file.write(json.dumps(config))

    config_file.close()