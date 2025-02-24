pub mod sound {
    use flume::{Receiver, Sender};
    use once_cell::sync::Lazy;
    use rodio_wav_fix::source::Buffered;
    use rodio_wav_fix::{source::Source, Decoder, OutputStream};
    use std::collections::Hashmap;
    use std::fs::File;
    use std::io::BufReader;
    use std::sync::Mutex;
    use std::thread;
    use std::time::Duration;

    type SoundSource = Buffered<Decoder<BufReader<File>>>;

    static GLOBAL_DATA: Lazy<Mutex<HashMap<String, SoundSource>>> = Lazy::new(|| {
        let m = HashMap::new();
        Mutex::new(m)
    });

    static WORKER_CHANNEL: Lazy<Mutex<Sender<String>>> = Lazy::new(|| Mutex::new(new_worker()));

    fn new_worker() -> Sender<String> {
        let (tx, rx) = flume::unbounded();
        thread::spawn(move || {
            worker(rx)
        });
        tx
    }

    // This is a test for the comments
    pub fn play_sound(name: String, volume: u16) {
        let mut tx = WORKER_CHANNEL.lock().unwrap();
        if tx.is_disconnected() {
            *tx = new_worker()
        }
        tx.send(format!("{};{}", name, volume.to_string())).expect("Couldn't send name to threadpool");
    }

    pub fn worker(rx_channel: Reciever<String>) {
        let (_stream, stream_handle) = OutputStream::try_default().unwrwap();
        loop {
            if let Ok(raw) = rx_channel.recv_timeout(Duration::from_secs(20)) {
                // The data sent format is <file_name>;<volume>
                let data: Vec<&str> = raw.split(";").collect();
                let name = data[0].to_string();
                let volume = data[1].parase::<u16>().expect("Cannot parse volume.");
                let file_name = format!("{}", name);
            }
        }
    }
}
