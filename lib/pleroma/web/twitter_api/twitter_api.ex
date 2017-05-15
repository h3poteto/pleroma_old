defmodule Pleroma.Web.TwitterAPI.TwitterAPI do
  alias Pleroma.{User, Activity, Repo, Object, Misc}
  alias Pleroma.Web.ActivityPub.ActivityPub

  def to_for_user_and_mentions(user, mentions) do
    default_to = [
      User.ap_followers(user),
      "https://www.w3.org/ns/activitystreams#Public"
    ]

    default_to ++ Enum.map(mentions, fn ({_, %{ap_id: ap_id}}) -> ap_id end)
  end

  def format_input(text, mentions) do
    text
    |> HtmlSanitizeEx.strip_tags
    |> String.replace("\n", "<br>")
    |> add_user_links(mentions)
  end

  def attachments_from_ids(ids) do
    Enum.map(ids || [], fn (media_id) ->
      Repo.get(Object, media_id).data
    end)
  end

  def get_replied_to_activity(id) when not is_nil(id) do
    Repo.get(Activity, id)
  end

  def get_replied_to_activity(_), do: nil

  def add_attachments(text, attachments) do
    attachment_text = Enum.map(attachments, fn
      (%{"url" => [%{"href" => href} | _]}) ->
        "<a href='#{href}' class='attachment'>#{href}</a>"
      _ -> ""
    end)
    Enum.join([text | attachment_text], "<br>")
    end

  def create_status(%User{} = user, %{"status" => status} = data) do
    attachments = attachments_from_ids(data["media_ids"])
    context = ActivityPub.generate_context_id
    mentions = parse_mentions(status)
    content_html = status
    |> format_input(mentions)
    |> add_attachments(attachments)

    to = to_for_user_and_mentions(user, mentions)
    date = Misc.make_date()

    in_reply_to = get_replied_to_activity(data["in_reply_to_status_id"])

    # Wire up reply info.
    [to, context, object, additional] =
      if in_reply_to do
      context = in_reply_to.data["context"]
      to = to ++ [in_reply_to.data["actor"]]

      object = %{
        "type" => "Note",
        "to" => to,
        "content" => content_html,
        "published" => date,
        "context" => context,
        "attachment" => attachments,
        "actor" => user.ap_id,
        "inReplyTo" => in_reply_to.data["object"]["id"],
        "inReplyToStatusId" => in_reply_to.id,
      }
      additional = %{}

      [to, context, object, additional]
      else
      object = %{
        "type" => "Note",
        "to" => to,
        "content" => content_html,
        "published" => date,
        "context" => context,
        "attachment" => attachments,
        "actor" => user.ap_id
      }
      [to, context, object, %{}]
    end

    ActivityPub.create(to, user, context, object, additional, data)
  end

  def parse_mentions(text) do
    # Modified from https://www.w3.org/TR/html5/forms.html#valid-e-mail-address
    regex = ~r/@[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@?[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*/

    regex
    |> Regex.scan(text)
    |> List.flatten
    |> Enum.uniq
    |> Enum.map(fn ("@" <> match = full_match) -> {full_match, User.get_cached_by_nickname(match)} end)
    |> Enum.filter(fn ({_match, user}) -> user end)
  end

  def add_user_links(text, mentions) do
    Enum.reduce(mentions, text, fn ({match, %User{ap_id: ap_id}}, text) -> String.replace(text, match, "<a href='#{ap_id}'>#{match}</a>") end)
  end

  def context_to_conversation_id(context) do
    with %Object{id: id} <- Object.get_cached_by_ap_id(context) do
      id
    else _e ->
      changeset = Object.context_mapping(context)
      {:ok, %{id: id}} = Repo.insert(changeset)
      id
    end
  end

  def conversation_id_to_context(id) do
    with %Object{data: %{"id" => context}} <- Repo.get(Object, id) do
      context
    else _e ->
      {:error, "No such conversation"}
    end
  end
end
