-- Create stream_messages table for live stream chat
CREATE TABLE public.stream_messages (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  stream_id UUID NOT NULL REFERENCES public.live_stream(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  display_name TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.stream_messages ENABLE ROW LEVEL SECURITY;

-- Anyone can view messages for active streams
CREATE POLICY "Anyone can view stream messages"
ON public.stream_messages
FOR SELECT
USING (true);

-- Authenticated users can send messages
CREATE POLICY "Authenticated users can send messages"
ON public.stream_messages
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Enable realtime for stream messages
ALTER PUBLICATION supabase_realtime ADD TABLE public.stream_messages;